import 'dart:typed_data';

import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'datasources/remote_datasource.dart';
import 'remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
class Environnement extends EnvironnementAbstractClass {
  const Environnement({
    required super.apiEndpoint,
    required super.httpClient,
  });
}

void main() {
  const String apiEndpoint = 'https://test.env';

  group('Remote datasource -', () {
    test('http response is List<String>', () async {
      final HttpClient httpClient = MockHttpClient();
      final Environnement env = Environnement(
        apiEndpoint: apiEndpoint,
        httpClient: httpClient,
      );

      when(
        httpClient.request(
          method: HttpMethod.get,
          path: '/todos/ids',
          endpoint: apiEndpoint,
          requestParameters: const RequestParameters(),
        ),
      ).thenAnswer(
        (_) => Future.value(
          HttpResponse.fromBody(
            statusCode: 200,
            body: '["todo1", "todo2"]',
          ),
        ),
      );

      final RemoteDatasource datasource = RemoteDatasource(env);

      final List<String> todos = await datasource.getTodosIds();

      expect(todos, ['todo1', 'todo2']);
    });

    test('http response is Map<String, dynamic>', () async {
      final HttpClient httpClient = MockHttpClient();
      final Environnement env = Environnement(
        apiEndpoint: apiEndpoint,
        httpClient: httpClient,
      );

      when(
        httpClient.request(
          method: HttpMethod.get,
          path: '/todos/:id',
          endpoint: apiEndpoint,
          requestParameters: const RequestParameters(
            routeParams: {
              'id': 'todoId',
            },
          ),
        ),
      ).thenAnswer(
        (_) => Future.value(
          HttpResponse.fromBody(
            statusCode: 200,
            body: '{"id": "todoId"}',
          ),
        ),
      );

      final RemoteDatasource datasource = RemoteDatasource(env);

      final Todo todo = await datasource.getTodo('todoId');

      expect(todo, const Todo('todoId'));
    });

    test('http response is List<Map<String, dynamic>>', () async {
      final HttpClient httpClient = MockHttpClient();
      final Environnement env = Environnement(
        apiEndpoint: apiEndpoint,
        httpClient: httpClient,
      );

      when(
        httpClient.request(
          method: HttpMethod.get,
          path: '/todos',
          endpoint: apiEndpoint,
          requestParameters: const RequestParameters(),
        ),
      ).thenAnswer(
        (_) => Future.value(
          HttpResponse.fromBody(
            statusCode: 200,
            body: '[{"id": "todoId1"}, {"id": "todoId2"}]',
          ),
        ),
      );

      final RemoteDatasource datasource = RemoteDatasource(env);

      final List<Todo> todos = await datasource.getTodos();

      expect(todos, [const Todo('todoId1'), const Todo('todoId2')]);
    });

    test('http response is Map with List<Map<String, dynamic>>', () async {
      final HttpClient httpClient = MockHttpClient();
      final Environnement env = Environnement(
        apiEndpoint: apiEndpoint,
        httpClient: httpClient,
      );

      when(
        httpClient.request(
          method: HttpMethod.get,
          path: '/todos',
          endpoint: apiEndpoint,
          requestParameters: const RequestParameters(),
        ),
      ).thenAnswer(
        (_) => Future.value(
          HttpResponse.fromBody(
            statusCode: 200,
            body: '{"todos": [{"id": "todoId1"}, {"id": "todoId2"}]}',
          ),
        ),
      );

      final RemoteDatasource datasource = RemoteDatasource(env);

      final List<Todo> todos = await datasource.getTodosWithKey();

      expect(todos, [const Todo('todoId1'), const Todo('todoId2')]);
    });

    group('http response is primitive -', () {
      test('String', () async {
        final HttpClient httpClient = MockHttpClient();
        final Environnement env = Environnement(
          apiEndpoint: apiEndpoint,
          httpClient: httpClient,
        );

        when(
          httpClient.request(
            method: HttpMethod.get,
            path: '/todos/todoId/id',
            endpoint: apiEndpoint,
            requestParameters: const RequestParameters(),
          ),
        ).thenAnswer(
          (_) => Future.value(
            HttpResponse(
              statusCode: 200,
              body: '{"id": "todoId"}',
              bytes: Uint8List(0),
            ),
          ),
        );

        final RemoteDatasource datasource = RemoteDatasource(env);

        final String todoId = await datasource.getTodosId();

        expect(todoId, 'todoId');
      });

      test('int', () async {
        final HttpClient httpClient = MockHttpClient();
        final Environnement env = Environnement(
          apiEndpoint: apiEndpoint,
          httpClient: httpClient,
        );

        when(
          httpClient.request(
            method: HttpMethod.get,
            path: '/todos/count',
            endpoint: apiEndpoint,
            requestParameters: const RequestParameters(),
          ),
        ).thenAnswer(
          (_) => Future.value(
            HttpResponse.fromBody(
              statusCode: 200,
              body: '{"count": 5}',
            ),
          ),
        );

        final RemoteDatasource datasource = RemoteDatasource(env);

        final int count = await datasource.getTodosCount();

        expect(count, 5);
      });
    });

    test('postProcessResponse is called', () async {
      final HttpClient httpClient = MockHttpClient();
      final Environnement env = Environnement(
        apiEndpoint: apiEndpoint,
        httpClient: httpClient,
      );

      when(
        httpClient.request(
          method: HttpMethod.get,
          path: '/todos/ids',
          endpoint: apiEndpoint,
          requestParameters: const RequestParameters(),
        ),
      ).thenThrow(
        HttpException.internalServerError(
          HttpResponse.fromBody(
            statusCode: 500,
            body: '',
          ),
        ),
      );

      final RemoteDatasource datasource = RemoteDatasource(env);

      expect(
        datasource.getTodosIds(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
