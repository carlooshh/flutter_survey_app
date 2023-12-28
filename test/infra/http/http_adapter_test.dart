import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({required String url, required String method}) async {
    await client.post(Uri.parse(url));
  }
}

@GenerateMocks([Client])
void main() {
  test("Shoul call http lib with the correct params", () {
    // Arrange
    final client = MockClient();
    final sut = HttpAdapter(client);
    final url = faker.internet.httpUrl();

    when(client.post(any, body: anyNamed('body')))
        .thenAnswer((_) async => Response('', 200));

    // Act
    sut.request(url: url, method: 'post');

    // Assert
    verify(client.post(Uri.parse(url)));
  });
}
