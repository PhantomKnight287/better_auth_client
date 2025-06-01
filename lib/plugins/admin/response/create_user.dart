import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/plugins/admin/response/set_role.dart';

class CreateUserResponse<T extends User> extends SetRoleResponse<T> {
  CreateUserResponse({required super.user});

  factory CreateUserResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) =>
      CreateUserResponse(user: fromJsonT(json['user']));

  @override
  String toString() => 'CreateUserResponse(user: $user)';
}
