import 'package:json_annotation/json_annotation.dart';

part "member_partial.g.dart";

@JsonSerializable()
class MemberPartial {
  final String id;
  final String userId;
  final String role;
  final String organizationId;

  MemberPartial({
    required this.id,
    required this.userId,
    required this.role,
    required this.organizationId,
  });

  factory MemberPartial.fromJson(Map<String, dynamic> json) => _$MemberPartialFromJson(json);

  Map<String, dynamic> toJson() => _$MemberPartialToJson(this);
}
