// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_partial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberPartial _$MemberPartialFromJson(Map<String, dynamic> json) =>
    MemberPartial(
      id: json['id'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$MemberPartialToJson(MemberPartial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'role': instance.role,
      'organizationId': instance.organizationId,
    };
