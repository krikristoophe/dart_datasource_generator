import 'package:dart_datasource_models/dart_datasource_models.dart';

/// Common environnement data
abstract class EnvironnementAbstractClass {
  ///
  const EnvironnementAbstractClass({
    required this.httpClient,
    required this.apiEndpoint,
  });

  /// Http client used to make http request
  final HttpClientBase httpClient;

  /// Default api endpoint used for requests
  final String apiEndpoint;
}
