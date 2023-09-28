import 'package:dart_datasource_generator/src/templates/template.dart';

/// function template
class FunctionTemplate extends Template {
  ///
  const FunctionTemplate({
    required this.name,
    required this.returnType,
    required this.content,
    this.parameters = const [],
  });

  /// name of function
  final String name;
  /// return type of function
  final String returnType;
  /// content of function
  final String content;
  /// parameters of function
  final List<FunctionParameterTemplate> parameters;

  @override
  String toString() {
    final String parametersStr = parameters
        .map((FunctionParameterTemplate parameter) => parameter.toString())
        .join(',');
    return '''
$returnType $name($parametersStr) {
  $content
}
''';
  }
}

/// function parameter template
class FunctionParameterTemplate extends Template {
  ///
  const FunctionParameterTemplate({
    required this.type,
    required this.name,
  });

  /// type of parameter
  final String type;

  /// name of parameter
  final String name;

  @override
  String toString() {
    return '$type $name';
  }
}
