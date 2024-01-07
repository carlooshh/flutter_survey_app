import 'dart:convert';

import 'package:flutter_survey_app/data/http/http_error.dart';
import 'package:http/http.dart';

import '../../data/http/http_client.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?> request(
      {required String url, required String method, Map? body}) async {
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonBody);

    if (response.statusCode == 400) throw HttpError.badRequest;

    if (response.statusCode == 401) throw HttpError.unauthorized;

    if (response.statusCode == 403) throw HttpError.forbidden;

    if (response.statusCode == 404) throw HttpError.notFound;

    if (response.statusCode == 500) throw HttpError.serverError;

    if (response.statusCode == 204) return null;

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}
