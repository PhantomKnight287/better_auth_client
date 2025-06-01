import 'package:better_auth_client/better_auth_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user_session.g.dart';

@JsonSerializable(createToJson: false)
class AdminUserSession extends Session {
  final String? impersonatedBy;
  final String? activeOrganizationId;

  AdminUserSession({
    required super.id,
    required super.expiresAt,
    required super.token,
    required super.createdAt,
    required super.updatedAt,
    required super.ipAddress,
    required super.userAgent,
    required super.userId,
    this.impersonatedBy,
    this.activeOrganizationId,
  });

  factory AdminUserSession.fromJson(Map<String, dynamic> json) => _$AdminUserSessionFromJson(json);
}
