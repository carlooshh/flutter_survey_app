import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({required String url, required String method}) async {
    super.noSuchMethod(
      Invocation.method(#request, [url, method]),
      returnValue: Future.value(),
    );
  }
}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    // Arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call httpClient with the correct URL', () async {
    // Act
    await sut.auth();

    // Assert
    verify(httpClient.request(url: url, method: 'post'));
  });
}
