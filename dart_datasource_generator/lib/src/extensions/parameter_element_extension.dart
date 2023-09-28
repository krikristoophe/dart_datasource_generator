import 'package:analyzer/dart/element/element.dart';

/// Extension on ParameterElement
extension ParameterElementExtension on ParameterElement {
  /// Convert parameter element to attribut mapping
  String get attributMapping {
    return '$name: $name,';
  }

  /// Convert parameter element to attribut mapping with variable
  String attributMappingWithVar(String variable) {
    return '$name: $variable.$name,';
  }
}

/// Extension on List<ParameterElement>
extension ListParameterElementExtension on List<ParameterElement> {
  /// Generate attributs mapping
  String get attributsMapping => map(
        (ParameterElement parameter) => parameter.attributMapping,
      ).join('\n');

  /// Generate attributs mapping with variable
  String attributsMappingWithVar(String variable) => map(
        (ParameterElement parameter) => parameter.attributMappingWithVar(
          variable,
        ),
      ).join('\n');
}
