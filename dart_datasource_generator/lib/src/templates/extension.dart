/// Template to generate dart exension
class ExtensionTemplate {
  ///
  const ExtensionTemplate({
    required this.name,
    required this.onProperty,
    this.children = const [],
  });

  /// [name] of extension
  final String name;

  /// Receiver of extension
  /// extension [name] on [onProperty]
  final String onProperty;

  /// Elements of extension
  final List<dynamic> children;

  @override
  String toString() {
    final String childrenString = children.join('\n');
    return '''
extension $name on $onProperty {
$childrenString
}
''';
  }
}
