import 'package:better_auth_client/plugins/organization/response/member_partial.dart';
import 'package:json_annotation/json_annotation.dart';

part "remove_member.g.dart";

@JsonSerializable()
class RemoveMemberResponse {
  final MemberPartial member;

  RemoveMemberResponse({
    required this.member,
  });

  factory RemoveMemberResponse.fromJson(Map<String, dynamic> json) => _$RemoveMemberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveMemberResponseToJson(this);
}
