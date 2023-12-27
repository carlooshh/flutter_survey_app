import 'package:flutter_survey_app/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:faker/faker.dart';

import 'package:flutter_survey_app/data/http/http.dart';
import 'package:flutter_survey_app/data/usecases/usecases.dart';
import 'package:flutter_survey_app/domain/usecases/usecases.dart';

import 'package:flutter_test/flutter_test.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late MockHttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call httpClient with the correct URL', () async {
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

  test('Should throw a UnexpectedError when httpClient returns 400', () async {
    when(httpClient.request(
            url: url, method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw a UnexpectedError when httpClient returns 404', () async {
    when(httpClient.request(
            url: url, method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw a UnexpectedError when httpClient returns 500', () async {
    when(httpClient.request(
            url: url, method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw a invalidCredentialsErros when httpClient returns 401',
      () async {
    when(httpClient.request(
            url: url, method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
