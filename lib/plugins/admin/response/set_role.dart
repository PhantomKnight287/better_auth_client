import 'package:better_auth_client/models/response/user.dart';

class SetRoleResponse<T extends User> {
  final T user;

  SetRoleResponse({required this.user});

  factory SetRoleResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) =>
      SetRoleResponse(user: fromJsonT(json['user']));

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {'user': toJsonT(user)};

  @override
  String toString() => 'SetRoleResponse(user: $user)';
}
