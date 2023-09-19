import 'package:dart_datasource_models/dart_datasource_models.dart';
import 'package:test/test.dart';

void main() {
  group('HttpClient -', () {
    group('buildUri -', () {
      test('override endpoint', () {
        const RequestParameters params = RequestParameters(
          endpointOverride: 'https://test-override.fr',
        );

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/',
          params: params,
        );

        expect(uri.toString(), 'https://test-override.fr/');
      });
      test('empty route params', () {
        const RequestParameters params = RequestParameters();

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/test',
          params: params,
        );

        expect(uri.toString(), 'https://test.fr/test');
      });

      test('one route params', () {
        const RequestParameters params = RequestParameters(
          routeParams: {
            'id': 'randomId',
          },
        );

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/:id',
          params: params,
        );

        expect(uri.toString(), 'https://test.fr/randomId');
      });

      test('multiple route params', () {
        const RequestParameters params = RequestParameters(
          routeParams: {
            'id': 'randomId',
            'secondId': 'secondRandomId',
          },
        );

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/:id/:secondId',
          params: params,
        );

        expect(uri.toString(), 'https://test.fr/randomId/secondRandomId');
      });

      test('empty query params', () {
        const RequestParameters params = RequestParameters();

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/test',
          params: params,
        );

        expect(uri.toString(), 'https://test.fr/test');
      });

      test('one query param', () {
        const RequestParameters params = RequestParameters(
          queryParams: {
            'param_1': 'value_1',
          },
        );

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/test',
          params: params,
        );

        expect(uri.toString(), 'https://test.fr/test?param_1=value_1');
      });

      test('multiple query params', () {
        const RequestParameters params = RequestParameters(
          queryParams: {
            'param_1': 'value_1',
            'param_2': 'value_2',
          },
        );

        final Uri uri = HttpClientBase.buildUri(
          endpoint: 'https://test.fr',
          path: '/test',
          params: params,
        );

        expect(
          uri.toString(),
          'https://test.fr/test?param_1=value_1&param_2=value_2',
        );
      });
    });
  });
}
