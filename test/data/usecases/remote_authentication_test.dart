import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(RemoteAuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  toJson() => {'email': email, 'password': password};
}

abstract class HttpClient {
  Future<void> request({required String url, required String method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    super.noSuchMethod(
      Invocation.method(#request, [url, method, body]),
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
    final params = RemoteAuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    // Act
    await sut.auth(params);

    // Assert
    verify(httpClient.request(url: url, method: 'post', body: params.toJson()));
  });
}
