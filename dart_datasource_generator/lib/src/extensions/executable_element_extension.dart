import 'package:analyzer/dart/element/element.dart';

/// Get usable name of function
extension ExecutableElementExtension on ExecutableElement {
  /// Returns the name of `this` qualified with the class name if it's a
  /// [MethodElement].
  String get qualifiedName {
    if (this is FunctionElement) {
      return name;
    }

    if (this is MethodElement) {
      return '${enclosingElement.name}.$name';
    }

    if (this is ConstructorElement) {
      // Ignore the default constructor.
      if (name.isEmpty) {
        return '${enclosingElement.name}';
      }
      return '${enclosingElement.name}.$name';
    }

    throw UnsupportedError(
      'Not sure how to support typeof $runtimeType',
    );
  }
}
