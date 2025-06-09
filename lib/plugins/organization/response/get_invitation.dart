import 'package:better_auth_client/plugins/organization/response/invitation.dart';
import 'package:json_annotation/json_annotation.dart';

part "get_invitation.g.dart";

@JsonSerializable()
class GetInvitationResponse extends Invitation {
  final String organizationName;
  final String organizationSlug;
  final String inviterEmail;
  GetInvitationResponse({
    required super.id,
    required this.organizationName,
    required this.organizationSlug,
    required this.inviterEmail,
    required super.email,
    required super.role,
    required super.organizationId,
    required super.inviterId,
    required super.status,
    super.expiresAt,
  });

  factory GetInvitationResponse.fromJson(Map<String, dynamic> json) => _$GetInvitationResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetInvitationResponseToJson(this);
}
