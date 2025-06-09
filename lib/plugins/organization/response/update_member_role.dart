import 'package:better_auth_client/plugins/organization/response/member_partial.dart';
import 'package:better_auth_client/plugins/organization/response/remove_member.dart';
import 'package:json_annotation/json_annotation.dart';

part "update_member_role.g.dart";

@JsonSerializable()
class UpdateMemberRoleResponse extends RemoveMemberResponse {
  UpdateMemberRoleResponse({
    required super.member,
  });

  factory UpdateMemberRoleResponse.fromJson(Map<String, dynamic> json) => _$UpdateMemberRoleResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateMemberRoleResponseToJson(this);
}
