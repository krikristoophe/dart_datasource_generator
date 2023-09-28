import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_datasource_generator/src/extensions/parameter_element_extension.dart';
import 'package:dart_datasource_generator/src/model_reporter_generator.dart';
import 'package:dart_datasource_generator/src/templates/class_constructor.dart';
import 'package:dart_datasource_generator/src/templates/freezed_class.dart';
import 'package:dart_datasource_generator/src/templates/function.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for remote datasource
class HiveModelReporterGenerator extends ModelReporterGenerator {
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

    final String libraryIdentifier = await getLibraryIdentifier(buildStep);

    final String partName = _getPartName(libraryIdentifier);

    final List<ParameterElement> parameters = getClassConstructorParameters(
      element,
    );

    final String attributMapping = parameters.attributsMapping;

    final FunctionTemplate toDtoMethod = FunctionTemplate(
      name: 'toDto',
      returnType: '${modelName}LocalDto',
      content: '''
return ${modelName}LocalDto(
  $attributMapping
);
''',
    );

    final List<TypedConstructorParameterTemplate> dtoConstructorParameters =
        parameters
            .map(
              (ParameterElement element) => TypedConstructorParameterTemplate(
                type: element.type.toString(),
                name: element.name,
                isRequired: element.isRequired,
              ),
            )
            .toList();

    final String fromDtoAttributMapping = parameters.attributsMappingWithVar(
      'dto',
    );
    final FactoryConstructorTemplate fromDtoFactory =
        FactoryConstructorTemplate(
      className: '${modelName}LocalDtoHive',
      name: 'fromDto',
      isConst: false,
      parameters: [
        FunctionParameterTemplate(
          type: '${modelName}LocalDto',
          name: 'dto',
        ),
      ],
      content: '''
return ${modelName}LocalDtoHive(
  $fromDtoAttributMapping
);
''',
    );

    final FreezedClassTemplate localDtoClass = FreezedClassTemplate(
      name: '${modelName}LocalDtoHive',
      parameters: dtoConstructorParameters,
      children: [
        toDtoMethod,
        fromDtoFactory,
      ],
    );

    return '''
import 'package:freezed_annotation/freezed_annotation.dart';
import '$libraryIdentifier';

part '$partName';

$localDtoClass
''';
  }

  String _getPartName(String libraryIdentifier) {
    return createPartName(libraryIdentifier, [
      'ddgm',
      'hive',
      'freezed',
    ]);
  }
}
