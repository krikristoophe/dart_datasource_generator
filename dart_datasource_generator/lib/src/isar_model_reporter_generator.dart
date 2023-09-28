import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_datasource_generator/src/extensions/parameter_element_extension.dart';
import 'package:dart_datasource_generator/src/model_reporter_generator.dart';
import 'package:dart_datasource_generator/src/templates/class.dart';
import 'package:dart_datasource_generator/src/templates/class_constructor.dart';
import 'package:dart_datasource_generator/src/templates/function.dart';
import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for remote datasource
class IsarModelReporterGenerator extends ModelReporterGenerator {
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

    final ConstructorTemplate constructor = ConstructorTemplate(
      name: '${modelName}LocalDtoIsar',
      parameters: constructorParametersFromParameters(parameters),
    );

    final String fromDtoAttributMapping = parameters.attributsMappingWithVar(
      'dto',
    );

    final FactoryConstructorTemplate fromDtoFactory =
        FactoryConstructorTemplate(
      className: '${modelName}LocalDtoIsar',
      name: 'fromDto',
      isConst: false,
      parameters: [
        FunctionParameterTemplate(
          type: '${modelName}LocalDto',
          name: 'dto',
        ),
      ],
      content: '''
return ${modelName}LocalDtoIsar(
  $fromDtoAttributMapping
);
''',
    );

    final ClassTemplate localDtoClass = ClassTemplate(
      name: '${modelName}LocalDtoIsar',
      children: [
        constructor,
        ...attributsFromParameters(parameters),
        toDtoMethod,
        fromDtoFactory,
      ],
    );

    return '''
import 'package:isar/isar.dart';
import '$libraryIdentifier';

part '$partName';

@Collection()
$localDtoClass
''';
  }

  String _getPartName(String libraryIdentifier) {
    return createPartName(libraryIdentifier, [
      'ddgm',
      'isar',
      'g',
    ]);
  }

  /// Create class attributs from parameters elements
  @override
  List<AttributTemplate> attributsFromParameters(
    List<ParameterElement> parameters,
  ) {
    return parameters.map(
      (ParameterElement element) {
        final Iterable<DartObject> annotations = const TypeChecker.fromRuntime(
          DGMId,
        ).annotationsOf(
          element,
        );

        final List<String> attributAnnotations = [];

        late final String type;
        if (annotations.isEmpty) {
          type = element.type.toString();
        } else {
          type = 'Id';
        }
        
        if (element.type.element is EnumElement) {
          attributAnnotations.add('@Enumerated(EnumType.name)');
        }

        return AttributTemplate(
          name: element.name,
          type: type,
          annotations: attributAnnotations,
        );
      },
    ).toList();
  }
}
