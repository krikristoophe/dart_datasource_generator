import 'package:dart_datasource_models/dart_datasource_models.dart';

@DartGeneratorLocalDatasource()
class LocalDatasource with _$LocalDatasource {
  const LocalDatasource(this.environnement);

  @override
  final EnvironnementAbstractClass environnement;
  Future<List<String>> getTodos() async {
    return [];
  }

  Future<void> saveTodos(List<String> todos) async {
    // TODO(christophe): save in cache
  }
}

mixin _$LocalDatasource implements LocalDatasourceAbstractClass {}
