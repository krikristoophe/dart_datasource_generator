import 'package:dart_datasource_models/dart_datasource_models.dart';

class Environnement extends EnvironnementAbstractClass {
  Environnement({
    required super.apiEndpoint,
  }) : super(
          httpClient: HttpClient(),
        );
}
