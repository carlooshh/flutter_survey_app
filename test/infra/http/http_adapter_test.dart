import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';
import 'package:flutter_survey_app/data/http/http_client.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?> request(
      {required String url, required String method, Map? body}) async {
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonBody);

    if (response.statusCode == 204) {
      return null;
    }

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

@GenerateMocks([Client])
void main() {
  late MockClient client;
  late HttpAdapter sut;
  late String url;
  late Map body;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    body = {'any_key': 'any_value'};
  });

  group('post', () {
    PostExpectation mockResponse() => when(
        client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    test("Shoul call http lib with the correct params", () {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      // Act
      sut.request(url: url, method: 'post', body: body);

      // Assert
      verify(client.post(
          Uri.parse(
            url,
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: jsonEncode(body)));
    });

    test("Shoul call http lib without body param", () {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      // Act
      sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      verify(client.post(
        Uri.parse(
          url,
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
      ));
    });

    test("Shoul return data if post return 200", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      // Act
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(response, {'any_key': 'any_value'});
    });

    test("Shoul return null if post return 200 without data", () async {
      mockResponse().thenAnswer((_) async => Response('', 200));

      // Act
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(response, null);
    });

    test("Shoul return null if post return 204", () async {
      mockResponse().thenAnswer((_) async => Response('', 204));

      // Act
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(response, null);
    });

    test("Shoul return null if post return 204 with data", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 204));

      // Act
      final response = await sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(response, null);
    });
  });
}
