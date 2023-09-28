import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_datasource_generator/src/extensions/parameter_element_extension.dart';
import 'package:dart_datasource_generator/src/templates/class.dart';
import 'package:dart_datasource_generator/src/templates/class_constructor.dart';
import 'package:dart_datasource_generator/src/templates/extension.dart';
import 'package:dart_datasource_generator/src/templates/freezed_class.dart';
import 'package:dart_datasource_generator/src/templates/function.dart';
import 'package:dart_datasource_generator/src/templates/mixin.dart';
import 'package:dart_datasource_generator/src/templates/template.dart';
import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for remote datasource
class ModelReporterGenerator
    extends GeneratorForAnnotation<DartGeneratorModel> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw ArgumentError('${element.name} is not a class');
    }

    final String modelName = element.name;

    final List<ParameterElement> parameters = getClassConstructorParameters(
      element,
    );

    final String attributMapping = parameters.attributsMapping;

    final MixinTemplate modelMixin = MixinTemplate(
      name: modelName,
      children: parameters
          .map(
            (ParameterElement parameter) => GetterTemplate(
              type: parameter.type.toString(),
              name: parameter.name,
              content: 'throw UnimplementedError()',
            ),
          )
          .toList(),
    );

    final ClassTemplate modelConstructorClass = ClassTemplate(
      name: '_$modelName',
      implementation: modelName,
      children: [
        ConstructorTemplate(
          name: '_$modelName',
          parameters: constructorParametersFromParameters(parameters),
        ),
        ...attributsFromParameters(parameters),
      ],
    );

    final FunctionTemplate toBusinessMethod = FunctionTemplate(
      name: 'toBusiness',
      returnType: modelName,
      content: '''
return $modelName(
  $attributMapping
);
''',
    );

    final List<TypedConstructorParameterTemplate> dtosConstructorParameters =
        parameters
            .map(
              (ParameterElement element) => TypedConstructorParameterTemplate(
                type: element.type.toString(),
                name: element.name,
                isRequired: element.isRequired,
              ),
            )
            .toList();

    final List<TypedConstructorParameterTemplate>
        dtosConstructorParametersWithJsonKey = parameters.map(
      (ParameterElement element) {
        final Iterable<DartObject> jsonKeys = const TypeChecker.fromRuntime(
          JsonKey,
        ).annotationsOf(
          element,
        );

        final List<Template> annotations = [];

        for (final DartObject jsonKey in jsonKeys) {
          annotations.add(JsonKeyAnnotationTemplate.fromDartObject(jsonKey));
        }

        return TypedConstructorParameterTemplate(
          type: element.type.toString(),
          name: element.name,
          isRequired: element.isRequired,
          annotations: annotations,
        );
      },
    ).toList();

    final FreezedClassTemplate remoteDtoClass = FreezedClassTemplate(
      name: '${modelName}RemoteDto',
      fromJson: true,
      parameters: dtosConstructorParametersWithJsonKey,
      children: [
        toBusinessMethod,
      ],
    );

    final String attributMappingLocalDtoFactory =
        parameters.attributsMappingWithVar(
      'business',
    );

    final FactoryConstructorTemplate localDtoFromBusinessFactory =
        FactoryConstructorTemplate(
      className: '${modelName}LocalDto',
      name: 'fromBusiness',
      isConst: false,
      parameters: [
        FunctionParameterTemplate(
          type: modelName,
          name: 'business',
        ),
      ],
      content: '''
return ${modelName}LocalDto(
  $attributMappingLocalDtoFactory
);
''',
    );

    final FreezedClassTemplate localDtoClass = FreezedClassTemplate(
      name: '${modelName}LocalDto',
      parameters: dtosConstructorParameters,
      children: [
        toBusinessMethod,
        localDtoFromBusinessFactory,
      ],
    );

    final FunctionTemplate listToBusinessFunction = FunctionTemplate(
      name: 'toBusiness',
      returnType: 'List<$modelName>',
      content: '''
return map((dto) => dto.toBusiness()).toList();
''',
    );

    final FunctionTemplate listToLocalDtoFunction = FunctionTemplate(
      name: 'toLocalDto',
      returnType: 'List<${modelName}LocalDto>',
      content: '''
return map((business) => ${modelName}LocalDto.fromBusiness(business)).toList();
''',
    );

    final ExtensionTemplate remoteDtoListExtension = ExtensionTemplate(
      name: '${modelName}RemoteDtoListExtension',
      onProperty: 'List<${modelName}RemoteDto>',
      children: [
        listToBusinessFunction,
      ],
    );

    final ExtensionTemplate localDtoListExtension = ExtensionTemplate(
      name: '${modelName}LocalDtoListExtension',
      onProperty: 'List<${modelName}LocalDto>',
      children: [
        listToBusinessFunction,
      ],
    );

    final ExtensionTemplate modelListExtension = ExtensionTemplate(
      name: '${modelName}ListExtension',
      onProperty: 'List<$modelName>',
      children: [
        listToLocalDtoFunction,
      ],
    );

    return '''
$modelMixin
$remoteDtoClass
$localDtoClass
$modelConstructorClass
$remoteDtoListExtension
$localDtoListExtension
$modelListExtension
''';
  }

  /// Get class [element] constructor parameters
  List<ParameterElement> getClassConstructorParameters(ClassElement element) {
    final ConstructorElement constructor = element.constructors.firstWhere(
      (ConstructorElement c) => c.isConst && c.isFactory,
    );

    final List<ParameterElement> parameters =
        constructor.children.whereType<ParameterElement>().toList();

    return parameters;
  }

  /// get library identifier (file name)
  Future<String> getLibraryIdentifier(BuildStep buildStep) async {
    final LibraryElement libraryElement = await buildStep.inputLibrary;
    final String libraryIdentifier = libraryElement.identifier;
    return libraryIdentifier;
  }

  /// create part name from current file
  String createPartName(
    String libraryIdentifier,
    List<String> parts,
  ) {
    final String fileName = libraryIdentifier.split('/').last;
    final List<String> fileNameParts = fileName.split('.');
    final String partName = (fileNameParts
          ..insertAll(
            fileNameParts.length - 1,
            parts,
          ))
        .join('.');
    return partName;
  }

  /// Create class attributs from parameters elements
  List<AttributTemplate> attributsFromParameters(
    List<ParameterElement> parameters,
  ) {
    return parameters
        .map(
          (ParameterElement element) => AttributTemplate(
            name: element.name,
            type: element.type.toString(),
          ),
        )
        .toList();
  }

  /// Create constructor parameters from parameters elements
  List<ConstructorParameterTemplate> constructorParametersFromParameters(
    List<ParameterElement> parameters,
  ) {
    return parameters
        .map(
          (ParameterElement element) => ConstructorParameterTemplate(
            name: element.name,
            isRequired: element.isRequired,
          ),
        )
        .toList();
  }
}
