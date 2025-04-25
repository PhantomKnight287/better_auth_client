import 'package:better_auth_client/models/response/user.dart';

/// A generic wrapper for User model that allows custom user model types
class UserWrapper<T extends User> {
  final T user;
  final String token;

  UserWrapper({required this.user, required this.token});

  factory UserWrapper.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return UserWrapper(user: fromJsonT(json['user']), token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}
