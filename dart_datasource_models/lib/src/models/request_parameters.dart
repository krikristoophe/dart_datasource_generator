import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_parameters.freezed.dart';

/// Parameters sent to requests
@Freezed()
class RequestParameters with _$RequestParameters {
  ///
  const factory RequestParameters({
    /// body sent to request
    @Default('') dynamic body,

    /// specific request headers
    @Default({}) Map<String, String> headers,

    /// parameters of route (ex: /test/:param)
    @Default({}) Map<String, String> routeParams,

    /// query parameters
    @Default({}) Map<String, String> queryParams,

    /// Override default endpoint of request
    String? endpointOverride,
  }) = _RequestParameters;
}
