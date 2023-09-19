import 'package:dart_datasource_models/dart_datasource_models.dart';

part 'remote_datasource.ddg.dart';

@DartGeneratorRemoteDatasource()
class RemoteDatasource with _$RemoteDatasource {
  const RemoteDatasource(this.environnement);

  @override
  final EnvironnementAbstractClass environnement;

  @DartGeneratorRequest(
    path: '/todos',
    method: HttpMethod.get,
  )
  Future<List<String>> getTodos() => _getTodos();
}

// ---------
// Generated
// ---------
/* mixin _$RemoteDatasource implements RemoteDatasourceAbstractClass {}

extension GetTodosRemoteDatasourceExtension on _$RemoteDatasource {
  Future<List<Todo>> _getTodos() async {
    final HttpResponse response = await environnement.httpClient.request(
      method: HttpMethod.get,
      path: '/todos',
      endpoint: environnement.apiEndpoint,
    );
    // TODO(christophe): body management
    print(response.body);
    return [];
  }
}
 */
