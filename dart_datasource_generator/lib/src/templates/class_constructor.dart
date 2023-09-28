import 'package:dart_datasource_generator/src/templates/function.dart';
import 'package:dart_datasource_generator/src/templates/template.dart';

/// Constructor parameter template
class ConstructorParameterTemplate extends Template {
  ///
  const ConstructorParameterTemplate({
    required this.name,
    this.isRequired = false,
  });

  /// name of parameter
  final String name;

  /// is parameter required
  final bool isRequired;

  @override
  String toString() {
    final String requiredStr = isRequired ? 'required' : '';
    return '$requiredStr this.$name'.trim();
  }
}

/// Typed constructor parameter template
class TypedConstructorParameterTemplate extends ConstructorParameterTemplate {
  ///
  const TypedConstructorParameterTemplate({
    required this.type,
    required super.name,
    super.isRequired,
    this.annotations = const [],
  });

  /// type of parameter
  final String type;

  /// annotations of parameter
  final List<Template> annotations;

  @override
  String toString() {
    final String requiredStr = isRequired ? 'required' : '';
    final String annotationsStr = annotations
        .map((Template annotation) => annotation.toString())
        .join('\n');
    return '''
$annotationsStr
$requiredStr $type $name
'''
        .trim();
  }
}

/// Constructor template
class ConstructorTemplate extends Template {
  ///
  const ConstructorTemplate({
    required this.name,
    this.isConst = true,
    this.parameters = const [],
  });

  /// name of constructor
  final String name;

  /// is constructor constant
  final bool isConst;

  /// parameters of constructor
  final List<ConstructorParameterTemplate> parameters;

  @override
  String toString() {
    final String constStr = isConst ? 'const' : '';
    final String parametersStr = parameters
        .map((ConstructorParameterTemplate parameter) => '$parameter,')
        .join('\n');
    return '''
$constStr $name({
  $parametersStr
});
''';
  }
}

/// factory constructor template
class FactoryConstructorTemplate extends Template {
  ///
  const FactoryConstructorTemplate({
    required this.className,
    required this.name,
    required this.content,
    this.isConst = true,
    this.parameters = const [],
  });

  /// name of class
  final String className;

  /// name of factory
  final String name;

  /// is factory constant
  final bool isConst;

  /// content of factory
  final String content;

  /// parameters of factory
  final List<FunctionParameterTemplate> parameters;

  @override
  String toString() {
    final String constStr = isConst ? 'const' : '';
    final String parametersStr = parameters
        .map((FunctionParameterTemplate parameter) => parameter.toString())
        .join(',');
    return '''
$constStr factory $className.$name($parametersStr) {
  $content
}
''';
  }
}
