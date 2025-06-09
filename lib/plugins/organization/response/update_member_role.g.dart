// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_member_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMemberRoleResponse _$UpdateMemberRoleResponseFromJson(
  Map<String, dynamic> json,
) => UpdateMemberRoleResponse(
  member: MemberPartial.fromJson(json['member'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateMemberRoleResponseToJson(
  UpdateMemberRoleResponse instance,
) => <String, dynamic>{'member': instance.member};
