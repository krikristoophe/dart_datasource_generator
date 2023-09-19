import 'package:analyzer/dart/element/type.dart';

/// DartTypeExtension
extension DartTypeExtension on DartType {
  /// is this type a dart primitive type
  bool get isPrimitive {
    return isDartCoreBool ||
        isDartCoreDouble ||
        isDartCoreInt ||
        isDartCoreNum ||
        isDartCoreString;
  }
}
