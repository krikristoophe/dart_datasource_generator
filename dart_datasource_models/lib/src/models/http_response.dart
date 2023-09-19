import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Http response returns by requests
class HttpResponse {
  ///
  const HttpResponse({
    required this.statusCode,
    required this.body,
    required this.bytes,
  });

  /// Create [HttpResponse] from String body
  /// encode [body] to bytes
  factory HttpResponse.fromBody({
    required int statusCode,
    required String body,
  }) {
    final Uint8List bytes = Uint8List.fromList(utf8.encode(body));
    return HttpResponse(
      statusCode: statusCode,
      body: body,
      bytes: bytes,
    );
  }

  /// Http status code
  final int statusCode;

  /// Http response as String
  final String body;

  /// Http response bytes
  final Uint8List bytes;

  /// Create [HttpResponse] from StreamedResponse
  static Future<HttpResponse> fromStreamedResponse(
    http.StreamedResponse streamedResponse,
  ) async {
    final http.ByteStream byteStream = streamedResponse.stream;
    final Uint8List bytes = await byteStream.toBytes();
    late final String body;

    try {
      body = utf8.decode(bytes);
    } catch (e) {
      body = '';
    }

    return HttpResponse(
      statusCode: streamedResponse.statusCode,
      body: body,
      bytes: bytes,
    );
  }
}
