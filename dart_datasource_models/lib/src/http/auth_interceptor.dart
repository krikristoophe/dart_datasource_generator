import 'package:http/http.dart' as http;

/// Definition of interceptor used to authenticate request
abstract class AuthInterceptor {
  ///
  const AuthInterceptor();

  /// Transform request with authentication data
  Future<T> authenticateRequest<T extends http.BaseRequest>(T request);
}

/// Basic auth interceptor to authenticate with bearer token
abstract class AuthorizationHeaderAuthInterceptor extends AuthInterceptor {
  ///
  const AuthorizationHeaderAuthInterceptor({
    this.prefix = '',
  });

  /// prefix of Authorisation header (Most of the time 'Bearer')
  final String prefix;

  /// Method used to get auth token (from secure storage for exemple)
  Future<String> loadAuthToken();

  @override
  Future<T> authenticateRequest<T extends http.BaseRequest>(T request) async {
    final String authToken = await loadAuthToken();

    final String headerValue = '$prefix $authToken'.trim();

    request.headers.putIfAbsent('Authorization', () => headerValue);

    return request;
  }
}
