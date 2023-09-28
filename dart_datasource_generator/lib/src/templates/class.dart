import 'package:analyzer/dart/constant/value.dart';
import 'package:dart_datasource_generator/src/templates/template.dart';
import 'package:source_gen/source_gen.dart';

/// Template to generate a class
class ClassTemplate extends Template {
  ///
  const ClassTemplate({
    required this.name,
    this.implementation,
    this.mixin,
    this.children = const [],
  });

  /// name of class
  final String name;

  /// implementation of class
  final String? implementation;

  /// with mixin
  final String? mixin;

  /// elements of class
  final List<Template> children;

  @override
  String toString() {
    final String implementationStr =
        implementation != null ? 'implements $implementation' : '';
    final String mixinStr = mixin != null ? 'with $mixin' : '';

    final String childrenStr =
        children.map((Template child) => child.toString()).join('\n\n');

    return '''
class $name $mixinStr $implementationStr {
  $childrenStr
}
''';
  }
}

/// Class attribut template
class AttributTemplate extends Template {
  ///
  const AttributTemplate({
    required this.type,
    required this.name,
    this.isFinal = true,
    this.annotations = const [],
  });

  /// type of attribut
  final String type;

  /// name of attribut
  final String name;

  /// is attribut final
  final bool isFinal;

  /// annotations of attribut
  final List<String> annotations;

  @override
  String toString() {
    final String finalStr = isFinal ? 'final' : '';
    final String annotationsStr = annotations.join('\n');
    return '''
$annotationsStr
$finalStr $type $name;'''
        .trim();
  }
}

/// Getter template
class GetterTemplate extends Template {
  ///
  const GetterTemplate({
    required this.type,
    required this.name,
    required this.content,
  });

  /// Type returned by getter
  final String type;

  /// name of getter
  final String name;

  /// content of getter
  final String content;

  @override
  String toString() {
    return '$type get $name => $content;';
  }
}

/// Annotation value template
class AnnotationParameterTemplate extends Template {
  ///
  const AnnotationParameterTemplate({
    required this.name,
    required this.value,
  });

  /// name of var
  final String name;

  /// value of var
  final String value;

  @override
  String toString() {
    return '$name: $value';
  }
}

/// template of annotation
class AnnotationTemplate extends Template {
  ///
  const AnnotationTemplate({
    required this.type,
    required this.parameters,
  });

  /// type of annotation
  final String type;

  /// parameters of annotation
  final List<AnnotationParameterTemplate> parameters;

  @override
  String toString() {
    final String parametersStr = parameters
        .map((AnnotationParameterTemplate parameter) => parameter.toString())
        .join(',');
    return '@$type($parametersStr)';
  }
}

/// template of JsonKey annotation
class JsonKeyAnnotationTemplate extends AnnotationTemplate {
  ///
  const JsonKeyAnnotationTemplate({
    required super.parameters,
  }) : super(type: 'JsonKey');

  /// Create JsonKey annotation from DartObject
  factory JsonKeyAnnotationTemplate.fromDartObject(DartObject object) {
    final ConstantReader r = ConstantReader(object);
    final List<AnnotationParameterTemplate> parameters = [];

    if (!r.read('name').isNull) {
      parameters.add(
        AnnotationParameterTemplate(
          name: 'name',
          value: "r'${r.read('name').stringValue}'",
        ),
      );
    }

    return JsonKeyAnnotationTemplate(
      parameters: parameters,
    );
  }
}
