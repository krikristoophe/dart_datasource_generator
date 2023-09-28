import 'package:dart_datasource_generator/src/templates/class_constructor.dart';
import 'package:dart_datasource_generator/src/templates/template.dart';

/// Freezed class template
class FreezedClassTemplate extends Template {
  ///
  const FreezedClassTemplate({
    required this.name,
    required this.parameters,
    this.fromJson = false,
    this.children = const [],
  });

  /// name of class
  final String name;

  /// generate from json
  final bool fromJson;

  /// other elements of class
  final List<Template> children;

  /// factory constructor parameters
  final List<TypedConstructorParameterTemplate> parameters;

  @override
  String toString() {
    final String fromJsonStr = fromJson
        ? '''
factory $name.fromJson(Map<String, dynamic> json) =>
      _\$${name}FromJson(json);
'''
        : '';

    final String parametersStr = parameters
        .map((TypedConstructorParameterTemplate parameter) => '$parameter,')
        .join('\n');

    final String childrenStr =
        children.map((Template child) => child.toString()).join('\n\n');

    return '''
@Freezed()
class $name with _\$$name {
  const $name._();
  const factory $name({
    $parametersStr
  }) = _$name;

  $fromJsonStr

  $childrenStr
}
''';
  }
}
