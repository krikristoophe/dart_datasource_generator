import 'dart:convert';

import 'package:dart_datasource_models/src/enums/http_method.dart';
import 'package:dart_datasource_models/src/http/auth_interceptor.dart';
import 'package:dart_datasource_models/src/models/http_exception.dart';
import 'package:dart_datasource_models/src/models/http_response.dart';
import 'package:dart_datasource_models/src/models/request_parameters.dart';
import 'package:easy_dart_logger/easy_dart_logger.dart';
import 'package:http/http.dart' as http;

export 'package:http/http.dart' show MultipartFile;

/// Base definition of HttpClient used to make requests
abstract class HttpClientBase {
  ///
  const HttpClientBase({
    this.defaultHeaders = const {},
    this.authInterceptor,
  });

  /// Default headers sent to every http requests
  final Map<String, String> defaultHeaders;

  /// Interceptor used to authenticate request if needed
  final AuthInterceptor? authInterceptor;

  /// Method called to execute request
  Future<HttpResponse> request({
    required HttpMethod method,
    required String path,
    required String endpoint,
    required RequestParameters requestParameters,
    bool authenticate = false,
    bool isMultipart = false,
  });

  /// Build request Uri from [endpoint], [path] and [params]
  /// [endpoint] is overrided by params.endpointOverride if provided
  static Uri buildUri({
    required String endpoint,
    required String path,
    required RequestParameters params,
  }) {
    final String computedEndpoint = params.endpointOverride ?? endpoint;

    String encodedPath = path;

    String query = '';

    if (params.queryParams.isNotEmpty) {
      final List<String> queries = params.queryParams.entries
          .map(
            (MapEntry<String, String> entry) => '${entry.key}=${entry.value}',
          )
          .toList();
      query = queries.join('&');
      query = '?$query';
    }

    params.routeParams.forEach((String key, String value) {
      encodedPath = encodedPath.replaceAll(':$key', value);
    });

    return Uri.parse(
      '$computedEndpoint$encodedPath$query',
    );
  }

  /// method used to process http [response] before return
  /// Can be used to map statusCode to exception for exemple
  Future<HttpResponse> processResponse(HttpResponse response);
}

/// Basic http client implementation
class HttpClient extends HttpClientBase {
  ///
  HttpClient({
    super.defaultHeaders,
    super.authInterceptor,
  });

  final http.Client _client = http.Client();

  static final DartLogger _logger = DartLogger(
    configuration: const DartLoggerConfiguration(
      format: LogFormat.inline,
      name: 'http_client',
    ),
  );

  /// Map HttpClient.buildUri to HttpClientBase.buildUri
  static Uri buildUri({
    required String endpoint,
    required String path,
    required RequestParameters params,
  }) =>
      HttpClientBase.buildUri(
        endpoint: endpoint,
        path: path,
        params: params,
      );

  @override
  Future<HttpResponse> request({
    required HttpMethod method,
    required String path,
    required String endpoint,
    required RequestParameters requestParameters,
    bool authenticate = false,
    bool isMultipart = false,
  }) async {
    final Uri uri = buildUri(
      endpoint: endpoint,
      path: path,
      params: requestParameters,
    );

    _logger.debug('[${method.name.toUpperCase()}] $uri');

    late http.BaseRequest request;

    if (isMultipart) {
      request = http.MultipartRequest(
        method.name,
        uri,
      );
    } else {
      request = http.Request(
        method.name,
        uri,
      );
    }

    final Map<String, String> headers = {
      ...defaultHeaders,
      ...requestParameters.headers,
    };

    request.headers.addAll(headers);

    late final String body;

    if (isMultipart) {
      request.headers.putIfAbsent('content-type', () => 'multipart/form-data');

      if (requestParameters.body is Map<String, dynamic>) {
        final Map<String, dynamic> body =
            requestParameters.body as Map<String, dynamic>;

        body.forEach(
          (key, value) {
            if (value is http.MultipartFile) {
              (request as http.MultipartRequest).files.add(value);
            } else if (value is List) {
              value.asMap().forEach((i, v) {
                (request as http.MultipartRequest)
                    .fields
                    .addAll({'$key[$i]': v.toString()});
              });
            } else {
              (request as http.MultipartRequest).fields.addAll(
                {key: value.toString()},
              );
            }
          },
        );
      } else {
        final dynamic body = requestParameters.body;
        final String runtimeType = body.runtimeType.toString();
        throw Exception(
          'body is not Map<String, dynamic> : $runtimeType',
        );
      }
    } else {
      if (requestParameters.body is Map) {
        body = json.encode(requestParameters.body);
        request.headers.putIfAbsent(
          'content-type',
          () => 'application/json',
        );
      } else {
        body = requestParameters.body.toString();
      }

      (request as http.Request).body = body;
    }

    if (authenticate && authInterceptor == null) {
      throw Exception('Authenticated request need authInterceptor');
    }

    if (authInterceptor != null && authenticate) {
      request = await authInterceptor?.authenticateRequest(request) ?? request;
    }

    final http.StreamedResponse httpResponse = await _client.send(request);

    final HttpResponse response = await HttpResponse.fromStreamedResponse(
      httpResponse,
    );

    return processResponse(response);
  }

  @override
  Future<HttpResponse> processResponse(HttpResponse response) async {
    final HttpException? exception = HttpException.fromResponse(response);

    if (exception != null) {
      throw exception;
    }

    return response;
  }
}
