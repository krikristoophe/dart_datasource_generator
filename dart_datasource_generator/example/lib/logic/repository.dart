import 'package:dart_datasource_generator_exemple/logic/local_datasource.dart';
import 'package:dart_datasource_generator_exemple/logic/remote_datasource.dart';
import 'package:dart_datasource_models/dart_datasource_models.dart';

@DartGeneratorRepository<RemoteDatasource, LocalDatasource>()
class Repository with _$Repository {
  Repository(this.environnement);

  @override
  final EnvironnementAbstractClass environnement;

  @DartRepositoryFunction(
    remote: 'getTodos',
    local: 'getTodos',
    saveLocal: 'saveTodos',
  )
  Future<List<String>> getTodos() => _getTodos();
}

// ---------
// Generated
// ---------

mixin _$Repository
    implements RepositoryAbstractClass<RemoteDatasource, LocalDatasource> {
  @override
  late final RemoteDatasource remote = RemoteDatasource(environnement);
  @override
  late final LocalDatasource local = LocalDatasource(environnement);

  Future<List<String>> _getTodos() async {
    try {
      final List<String> remoteResult = await remote.getTodos();
      await local.saveTodos(remoteResult);
      return remoteResult;
    } catch (e) {
      return local.getTodos();
    }
  }
}
