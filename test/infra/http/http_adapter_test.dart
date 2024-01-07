import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_survey_app/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'http_adapter_test.mocks.dart';

import 'package:flutter_survey_app/infra/http/http.dart';

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

    test("Shoul return BadRequestError if post return 400", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 400));

      // Act
      final future = sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(future, throwsA(HttpError.badRequest));
    });

    test("Shoul return ServerError if post return 500", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 500));

      // Act
      final future = sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(future, throwsA(HttpError.serverError));
    });

    test("Shoul return UnauthorizedError if post return 401", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 401));

      // Act
      final future = sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Shoul return ForbiddenError if post return 403", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 403));

      // Act
      final future = sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(future, throwsA(HttpError.forbidden));
    });

    test("Shoul return NotFoundError if post return 404", () async {
      mockResponse()
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 404));

      // Act
      final future = sut.request(
        url: url,
        method: 'post',
      );

      // Assert
      expect(future, throwsA(HttpError.notFound));
    });
  });
}
