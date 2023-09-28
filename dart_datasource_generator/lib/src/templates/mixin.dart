import 'package:dart_datasource_generator/src/templates/template.dart';

/// Template to generate mixin
class MixinTemplate {
  ///
  const MixinTemplate({
    required this.name,
    this.implementation,
    this.children = const [],
  });

  /// [name] of mixin
  final String name;

  /// implementation of mixin
  /// mixin [name] implements [implementation]
  final String? implementation;

  /// elements of mixin
  final List<Template> children;

  String get _mixinProperties {
    String properties = '';

    if (implementation != null) {
      properties += 'implements $implementation';
    }

    return properties;
  }

  @override
  String toString() {
    final String childrenStr =
        children.map((Template child) => child.toString()).join('\n');
    return '''
mixin _\$$name $_mixinProperties {
$childrenStr
}
''';
  }
}
