import 'user_data.dart';

class User {
  UserData? user;
  String? accessToken;
  String? tokenType;
  String? expiresAt;

  User({this.user, this.accessToken, this.tokenType, this.expiresAt});

  User.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user?.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    return data;
  }

  @override
  String toString() {
    return 'User{user: $user, accessToken: $accessToken, tokenType: $tokenType, expiresAt: $expiresAt}';
  }
}
