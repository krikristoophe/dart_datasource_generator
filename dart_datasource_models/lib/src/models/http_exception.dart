import 'package:dart_datasource_models/src/models/http_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_exception.freezed.dart';

/// Default http exceptions throws
@freezed
class HttpException with _$HttpException implements Exception {
  /// Unknown status code
  const factory HttpException.unknown(
    HttpResponse response,
  ) = _Unknown;

  // 4xx
  /// 400
  const factory HttpException.badRequest(
    HttpResponse response,
  ) = _BadRequest;

  /// 401
  const factory HttpException.unauthorized(
    HttpResponse response,
  ) = _Unauthorized;

  /// 403
  const factory HttpException.forbidden(
    HttpResponse response,
  ) = _Forbidden;

  /// 404
  const factory HttpException.notFound(
    HttpResponse response,
  ) = _NotFound;

  /// 405
  const factory HttpException.methodNotAllowed(
    HttpResponse response,
  ) = _MethodNotAllowed;

  /// 409
  const factory HttpException.conflict(
    HttpResponse response,
  ) = _Conflict;

  // 5xx
  /// 500
  const factory HttpException.internalServerError(
    HttpResponse response,
  ) = _InternalServerError;

  /// 501
  const factory HttpException.notImplemeted(
    HttpResponse response,
  ) = _NotImplemented;

  /// 502
  const factory HttpException.badGateway(
    HttpResponse response,
  ) = _BadGateway;

  /// Create HttpException from [response] statusCode
  static HttpException? fromResponse(HttpResponse response) {
    final int statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return null;
    }

    switch (statusCode) {
      case 400:
        return HttpException.badRequest(response);
      case 401:
        return HttpException.unauthorized(response);
      case 403:
        return HttpException.forbidden(response);
      case 404:
        return HttpException.notFound(response);
      case 405:
        return HttpException.methodNotAllowed(response);
      case 409:
        return HttpException.conflict(response);
      case 500:
        return HttpException.internalServerError(response);
      case 501:
        return HttpException.notImplemeted(response);
      case 502:
        return HttpException.badGateway(response);
    }

    return HttpException.unknown(response);
  }
}
