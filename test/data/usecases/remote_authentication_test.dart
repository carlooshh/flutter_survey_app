import 'package:faker/faker.dart';
import 'package:flutter_survey_app/data/http/http.dart';
import 'package:flutter_survey_app/data/usecases/usecases.dart';
import 'package:flutter_survey_app/domain/usecases/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    // Act
    await sut.auth(params);

    // Assert
    verify(httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromModel(
                email: params.email, password: params.password)
            .toJson()));
  });
}
