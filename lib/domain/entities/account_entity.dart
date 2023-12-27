class AccountEntity {
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw Exception();
    }
    return AccountEntity(json['accessToken']);
  }
}
