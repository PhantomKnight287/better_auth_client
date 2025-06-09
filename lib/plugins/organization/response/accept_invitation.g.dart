// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptInvitationResponse _$AcceptInvitationResponseFromJson(
  Map<String, dynamic> json,
) => AcceptInvitationResponse(
  invitation: Invitation.fromJson(json['invitation'] as Map<String, dynamic>),
  member: OrganizationMember.fromJson(json['member'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AcceptInvitationResponseToJson(
  AcceptInvitationResponse instance,
) => <String, dynamic>{
  'invitation': instance.invitation,
  'member': instance.member,
};
