import 'package:build/build.dart';
import 'package:dart_datasource_generator/src/datasource_reporter_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builder for datasource generation
Builder datasourceReporter(BuilderOptions options) {
  return PartBuilder(
    [
      RemoteDatasourceReporterGenerator(),
    ],
    '.ddg.dart',
    header: '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: library_private_types_in_public_api, only_throw_errors
// ignore_for_file: avoid_redundant_argument_values, unnecessary_lambdas, unnecessary_raw_strings
    ''',
  );
}
