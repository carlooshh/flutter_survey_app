import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request(
      {required String url, required String method, Map? body}) async {
    final jsonBody = body != null ? jsonEncode(body) : null;

    await client.post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonBody);
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

  test("Shoul call http lib with the correct params", () {
    when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 200));

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
    when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 200));

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
}
