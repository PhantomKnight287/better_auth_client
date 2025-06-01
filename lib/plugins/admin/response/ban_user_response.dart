import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/plugins/admin/response/set_role.dart';

class BanUserResponse<T extends User> extends SetRoleResponse<T> {
  BanUserResponse({required super.user});

  factory BanUserResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) =>
      BanUserResponse(user: fromJsonT(json["user"]));

  @override
  String toString() {
    return "BanUserResponse(user: $user)";
  }
}

class UnbanUserResponse<T extends User> extends SetRoleResponse<T> {
  UnbanUserResponse({required super.user});

  factory UnbanUserResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) =>
      UnbanUserResponse(user: fromJsonT(json["user"]));
}
