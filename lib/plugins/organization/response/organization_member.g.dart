// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationMember _$OrganizationMemberFromJson(Map<String, dynamic> json) =>
    OrganizationMember(
      id: json['id'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      organizationId: json['organizationId'] as String,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrganizationMemberToJson(OrganizationMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'role': instance.role,
      'organizationId': instance.organizationId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
