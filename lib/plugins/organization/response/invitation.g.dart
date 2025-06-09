// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) => Invitation(
  id: json['id'] as String,
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

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'organizationId': instance.organizationId,
      'inviterId': instance.inviterId,
      'status': instance.status,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
