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

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
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

  test('Should throw a UnexpectedError when httpClient returns 400', () async {
    when(httpClient.request(
            url: url, method: anyNamed('method'), body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
