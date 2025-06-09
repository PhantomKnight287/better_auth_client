import 'package:better_auth_client/plugins/organization/response/invitation.dart';
import 'package:better_auth_client/plugins/organization/response/organization_member.dart';
import 'package:json_annotation/json_annotation.dart';

part "accept_invitation.g.dart";

@JsonSerializable()
class AcceptInvitationResponse {
  final Invitation invitation;
  final OrganizationMember member;

  AcceptInvitationResponse({
    required this.invitation,
    required this.member,
  });

  factory AcceptInvitationResponse.fromJson(Map<String, dynamic> json) => _$AcceptInvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptInvitationResponseToJson(this);
}
