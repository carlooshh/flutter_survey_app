import 'package:flutter_survey_app/data/http/http.dart';

import '../../domain/usecases/usecases.dart';

import 'usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromModel(
                email: params.email, password: params.password)
            .toJson());
  }
}
