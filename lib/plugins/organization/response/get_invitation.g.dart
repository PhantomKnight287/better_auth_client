// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvitationResponse _$GetInvitationResponseFromJson(
  Map<String, dynamic> json,
) => GetInvitationResponse(
  id: json['id'] as String,
  organizationName: json['organizationName'] as String,
  organizationSlug: json['organizationSlug'] as String,
  inviterEmail: json['inviterEmail'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  organizationId: json['organizationId'] as String,
  inviterId: json['inviterId'] as String,
  status: json['status'] as String,
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$GetInvitationResponseToJson(
  GetInvitationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': instance.role,
  'organizationId': instance.organizationId,
  'inviterId': instance.inviterId,
  'status': instance.status,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'organizationName': instance.organizationName,
  'organizationSlug': instance.organizationSlug,
  'inviterEmail': instance.inviterEmail,
};
