import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/plugins/admin/response/admin_user_session.dart';

class ImpersonateUserResponse<T extends User> {
  final AdminUserSession session;
  final T user;

  ImpersonateUserResponse({required this.session, required this.user});

  factory ImpersonateUserResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) => ImpersonateUserResponse(session: AdminUserSession.fromJson(json["session"]), user: fromJsonT(json["user"]));

  @override
  String toString() {
    return "ImpersonateUserResponse(session: $session, user: $user)";
  }
}
