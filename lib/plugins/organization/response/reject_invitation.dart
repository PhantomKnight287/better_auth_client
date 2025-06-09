import 'package:better_auth_client/plugins/organization/response/invitation.dart';
import 'package:json_annotation/json_annotation.dart';

part "reject_invitation.g.dart";

@JsonSerializable()
class RejectInvitationResponse {
  final Invitation invitation;

  RejectInvitationResponse({
    required this.invitation,
  });

  factory RejectInvitationResponse.fromJson(Map<String, dynamic> json) => _$RejectInvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RejectInvitationResponseToJson(this);
}
