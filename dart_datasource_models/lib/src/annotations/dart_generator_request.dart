import 'package:dart_datasource_models/src/enums/http_method.dart';
import 'package:dart_datasource_models/src/models/http_exception.dart';

/// Annotation for http request generator
class DartGeneratorRequest {
  ///
  const DartGeneratorRequest({
    required this.path,
    required this.method,
    this.authenticate = false,
    this.readJsonKey,
    this.mapException,
  });

  /// Path of rest api request
  final String path;

  /// Http method of request
  final HttpMethod method;

  /// is request authenticated
  final bool authenticate;

  /// key used to find response data
  final String? readJsonKey;

  /// custom map of HttpException to another custom Exception
  final Object? Function(
    HttpException exception,
  )? mapException;
}
