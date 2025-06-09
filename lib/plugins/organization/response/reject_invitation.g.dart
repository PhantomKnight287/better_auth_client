// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectInvitationResponse _$RejectInvitationResponseFromJson(
  Map<String, dynamic> json,
) => RejectInvitationResponse(
  invitation: Invitation.fromJson(json['invitation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RejectInvitationResponseToJson(
  RejectInvitationResponse instance,
) => <String, dynamic>{'invitation': instance.invitation};
