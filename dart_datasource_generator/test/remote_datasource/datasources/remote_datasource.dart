import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:meta/meta.dart';

part 'remote_datasource.ddg.dart';

@immutable
class Todo {
  const Todo(this.id);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(json['id'] as String);
  }
  final String id;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other is! Todo) {
      return false;
    }

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@DartGeneratorRemoteDatasource()
class RemoteDatasource with _$RemoteDatasource {
  const RemoteDatasource(this.environnement);

  @override
  final EnvironnementAbstractClass environnement;

  static Object? _mapExceptions(
    HttpException exception,
  ) {
    return exception.maybeWhen(
      internalServerError: (response) => UnimplementedError(),
      orElse: () => null,
    );
  }

  @DartGeneratorRequest(
    path: '/todos/ids',
    method: HttpMethod.get,
    mapException: RemoteDatasource._mapExceptions,
    log: false,
  )
  Future<List<String>> getTodosIds() => _getTodosIds();

  @DartGeneratorRequest(
    path: '/todos/:id',
    method: HttpMethod.get,
  )
  Future<Todo> getTodo(String todoId) => _getTodo(
        RequestParameters(
          routeParams: {'id': todoId},
        ),
      );

  @DartGeneratorRequest(
    path: '/todos',
    method: HttpMethod.get,
  )
  Future<List<Todo>> getTodos() => _getTodos();

  @DartGeneratorRequest(
    path: '/todos',
    method: HttpMethod.post,
    authenticate: true,
  )
  Future<void> createTodo(Todo todo) => _createTodo(
        RequestParameters(
          body: todo.toJson(),
        ),
      );

  @DartGeneratorRequest(
    path: '/todos',
    method: HttpMethod.get,
    readJsonKey: 'todos',
  )
  Future<List<Todo>> getTodosWithKey() => _getTodosWithKey();

  @DartGeneratorRequest(
    path: '/todos/todoId/id',
    method: HttpMethod.get,
    readJsonKey: 'id',
  )
  Future<String> getTodosId() => _getTodosId();

  @DartGeneratorRequest(
    path: '/todos/count',
    method: HttpMethod.get,
    readJsonKey: 'count',
  )
  Future<int> getTodosCount() => _getTodosCount();
}
