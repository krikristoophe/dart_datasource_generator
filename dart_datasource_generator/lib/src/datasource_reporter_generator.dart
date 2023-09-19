import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_datasource_generator/src/extensions/dart_generator_request_extension.dart';
import 'package:dart_datasource_generator/src/templates/mixin.dart';
import 'package:dart_datasource_generator/src/templates/request_extension.dart';
import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for remote datasource
class RemoteDatasourceReporterGenerator
    extends GeneratorForAnnotation<DartGeneratorRemoteDatasource> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final String datasourceName = element.name!;
    final String generatedChildrenElements =
        await _generateForAnnotatedChildren(
      element.children,
      datasourceName,
    );

    final MixinTemplate template = MixinTemplate(
      name: element.name!,
      implementation: 'RemoteDatasourceAbstractClass',
    );
    return '''
$template

$generatedChildrenElements
''';
  }

  FutureOr<String> _generateForAnnotatedChildren(
    List<Element> children,
    String datasourceName,
  ) async {
    final List<String> allGeneratedChildren = [];
    for (final Element child in children) {
      final String? requestGeneratedCode = await _generateRequestAnnotation(
        child,
        datasourceName,
      );

      if (requestGeneratedCode != null) {
        allGeneratedChildren.add(requestGeneratedCode);
      }
    }

    return allGeneratedChildren.join('\n');
  }

  FutureOr<String?> _generateRequestAnnotation(
    Element element,
    String datasourceName,
  ) {
    final Iterable<DartObject> annotations = const TypeChecker.fromRuntime(
      DartGeneratorRequest,
    ).annotationsOf(
      element,
    );

    if (annotations.isNotEmpty) {
      final DartObject annotation = annotations.single;

      final DartGeneratorRequestExtension requestAnnotation =
          DartGeneratorRequestExtension.fromDartObject(
        annotation,
      );

      return RequestExtensionTemplate(
        element: element,
        datasourceName: datasourceName,
        request: requestAnnotation,
      ).toString();
    }

    return null;
  }
}
