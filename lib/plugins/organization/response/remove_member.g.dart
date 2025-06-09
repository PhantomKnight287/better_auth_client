// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveMemberResponse _$RemoveMemberResponseFromJson(
  Map<String, dynamic> json,
) => RemoveMemberResponse(
  member: MemberPartial.fromJson(json['member'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RemoveMemberResponseToJson(
  RemoveMemberResponse instance,
) => <String, dynamic>{'member': instance.member};
