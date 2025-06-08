import 'package:better_auth_client/plugins/organization/response/member_partial.dart';
import 'package:json_annotation/json_annotation.dart';

part "organization_member.g.dart";

@JsonSerializable()
class OrganizationMember extends MemberPartial {
  final DateTime? createdAt;

  OrganizationMember({
    required super.id,
    required super.userId,
    required super.role,
    required super.organizationId,
    this.createdAt,
  });

  factory OrganizationMember.fromJson(Map<String, dynamic> json) => _$OrganizationMemberFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrganizationMemberToJson(this);
}
