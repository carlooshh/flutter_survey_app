class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromModel(
          {required String email, required String password}) =>
      RemoteAuthenticationParams(email: email, password: password);

  toJson() => {'email': email, 'password': password};
}
