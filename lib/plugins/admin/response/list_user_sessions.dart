import 'package:better_auth_client/plugins/admin/response/admin_user_session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list_user_sessions.g.dart';

@JsonSerializable(createToJson: false)
class ListUserSessionsResponse {
  final List<AdminUserSession> sessions;

  ListUserSessionsResponse({required this.sessions});

  factory ListUserSessionsResponse.fromJson(Map<String, dynamic> json) => _$ListUserSessionsResponseFromJson(json);
}
