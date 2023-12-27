import 'package:flutter_survey_app/data/http/http.dart';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';

import 'usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromModel(
            email: params.email, password: params.password)
        .toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
