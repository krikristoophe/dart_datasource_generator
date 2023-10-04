import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dart_datasource_generator/src/extensions/dart_generator_request_extension.dart';
import 'package:dart_datasource_generator/src/extensions/dart_type_extension.dart';
import 'package:dart_datasource_generator/src/templates/extension.dart';
import 'package:recase/recase.dart';

/// Template of request extension
class RequestExtensionTemplate {
  ///
  const RequestExtensionTemplate({
    required this.element,
    required this.datasourceName,
    required this.request,
  });

  /// Dart [element] method annoted
  final Element element;

  /// Name of remote datasource that contains this request
  final String datasourceName;

  /// request annotation that make this generation
  final DartGeneratorRequestExtension request;

  @override
  String toString() {
    final String requestName = element.name!;

    final MethodElement e = element as MethodElement;

    final DartType returnTypeFutured = e.type.returnType;

    final ParameterizedType parameterizedType =
        returnTypeFutured as ParameterizedType;

    final DartType returnType = parameterizedType.typeArguments.first;

    late final String processResponse;

    bool isResponseUsed = true;

    if (returnType.isPrimitive) {
      if (returnType.isDartCoreString) {
        processResponse = '''
return json.decode(responseBody) as String;
''';
      } else if (returnType.isDartCoreInt) {
        processResponse = '''
return int.parse(responseBody);
''';
      } else {
        throw UnimplementedError('$returnType not implemented');
      }
    } else if (returnType.isDartCoreList) {
      final ParameterizedType listReturnType = returnType as ParameterizedType;
      final DartType listType = listReturnType.typeArguments.first;

      late final String returnStatement;

      if (listType.isPrimitive) {
        returnStatement = 'return body.cast<$listType>();';
      } else {
        returnStatement = '''
return body
  .cast<Map<String, dynamic>>()
  .map((Map<String, dynamic> item) => $listType.fromJson(item))
  .toList();
''';
      }

      processResponse = '''
final List<dynamic> body = json.decode(responseBody) as List<dynamic>;
$returnStatement
''';
    } else if (returnType is VoidType) {
      processResponse = '';
      isResponseUsed = false;
    } else {
      processResponse = '''
final Map<String, dynamic> body = json.decode(responseBody) as Map<String, dynamic>;

return $returnType.fromJson(body);
''';
    }

    late final String readBody;

    if (request.readJsonKey != null) {
      readBody = '''
final Map<String, dynamic> bodyMap = json.decode(response.body) as Map<String, dynamic>;
final String responseBody = json.encode(bodyMap[r'${request.readJsonKey}']);
''';
    } else {
      readBody = '''
final String responseBody = response.body;
''';
    }

    bool isExceptionUsed = false;

    String mapException = 'rethrow;';

    if (request.mapExceptionName != null) {
      isExceptionUsed = true;
      mapException = '''
final Object? exception = ${request.mapExceptionName}.call(e);
if (exception != null) {
  throw exception;
}
rethrow;
''';
    }

    return ExtensionTemplate(
      name: ReCase('$requestName${datasourceName}Extension').pascalCase,
      onProperty: '_\$$datasourceName',
      children: [
        '''
$returnTypeFutured _$requestName([
  RequestParameters params = const RequestParameters(),
]) async {
  ${isResponseUsed ? 'late final HttpResponse response;' : ''}
  try {
    ${isResponseUsed ? 'response = ' : ''}await environnement.httpClient.request(
      method: ${request.method},
      path: '${request.path}',
      endpoint: environnement.apiEndpoint,
      requestParameters: params,
      authenticate: ${request.authenticate},
      log: ${request.log},
    );
  } on HttpException catch(${isExceptionUsed ? 'e' : '_'}) {
    $mapException
  } catch(e) {
    rethrow;
  }

  ${isResponseUsed ? readBody : ''}
  
  $processResponse
}
''',
      ],
    ).toString();
  }
}
