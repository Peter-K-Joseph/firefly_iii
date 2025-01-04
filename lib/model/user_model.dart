import 'package:firefly_iii/model/enums.dart';

class UserModel {
  String? name;
  String? email;
  String? link;
  TokenType? tokenType;
  String? accessToken;
  DateTime? accessTokenExpiresAt;
  String? refreshToken;
  String? oauthClientID;
  String? oauthClientSecret;
  bool isDefault = false;

  UserModel({
    this.name,
    this.email,
    this.link,
    this.tokenType,
    this.accessToken,
    this.accessTokenExpiresAt,
    this.refreshToken,
    this.oauthClientID,
    this.oauthClientSecret,
    this.isDefault = false,
  });

  Map<String, Object?> toDatabaseFormat() {
    Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (link != null) data['link'] = link;
    if (tokenType != null) {
      data['tokenType'] = tokenType!.name;
    }
    if (accessToken != null) data['accessToken'] = accessToken;
    if (accessTokenExpiresAt != null) {
      data['accessTokenExpiresAt'] = accessTokenExpiresAt!.toIso8601String();
    }
    if (refreshToken != null) data['refreshToken'] = refreshToken;
    if (oauthClientID != null) data['oauthClientID'] = oauthClientID;
    if (oauthClientSecret != null) {
      data['oauthClientSecret'] = oauthClientSecret;
    }
    data['isDefault'] = isDefault ? 1 : 0;
    return data;
  }
}
