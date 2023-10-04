import 'package:analyzer/dart/constant/value.dart';
import 'package:dart_datasource_generator/src/extensions/executable_element_extension.dart';
import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:source_gen/source_gen.dart';

/// Extension of DartGeneratorRequest for use in generator
class DartGeneratorRequestExtension extends DartGeneratorRequest {
  ///
  DartGeneratorRequestExtension({
    required super.path,
    required super.method,
    required super.authenticate,
    required super.readJsonKey,
    required super.log,
    required this.mapExceptionName,
  });

  /// Create [DartGeneratorRequestExtension] from DartObject [object]
  factory DartGeneratorRequestExtension.fromDartObject(DartObject object) {
    final ConstantReader r = ConstantReader(object);

    final String path = r.read('path').stringValue;

    final HttpMethod method = HttpMethod.fromIndex(
      r.read('method').read('index').intValue,
    );

    final bool authenticate = r.read('authenticate').boolValue;

    final bool log = r.read('log').boolValue;

    final ConstantReader readJsonKeyReader = r.read('readJsonKey');

    final String? readJsonKey =
        readJsonKeyReader.isNull ? null : readJsonKeyReader.stringValue;

    final DartObject? mapExceptionObject = object.getField('mapException');

    final String? mapException =
        mapExceptionObject?.toFunctionValue()?.qualifiedName;

    return DartGeneratorRequestExtension(
      path: path,
      method: method,
      authenticate: authenticate,
      readJsonKey: readJsonKey,
      mapExceptionName: mapException,
      log: log,
    );
  }

  /// Name of function [mapException]
  final String? mapExceptionName;
}
