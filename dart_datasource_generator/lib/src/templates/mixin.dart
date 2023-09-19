/// Template to generate mixin
class MixinTemplate {
  ///
  const MixinTemplate({
    required this.name,
    this.implementation,
  });

  /// [name] of mixin
  final String name;

  /// implementation of mixin
  /// mixin [name] implements [implementation]
  final String? implementation;

  String get _mixinProperties {
    String properties = '';

    if (implementation != null) {
      properties += 'implements $implementation';
    }

    return properties;
  }

  @override
  String toString() {
    return '''
mixin _\$$name $_mixinProperties {

}
''';
  }
}
