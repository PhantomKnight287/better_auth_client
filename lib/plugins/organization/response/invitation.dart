import 'package:json_annotation/json_annotation.dart';

part "invitation.g.dart";

@JsonSerializable()
class Invitation {
  final String id;
  final String email;
  final String role;
  final String organizationId;
  final String inviterId;
  final String status;
  final DateTime? expiresAt;

  Invitation({
    required this.id,
    required this.email,
    required this.role,
    required this.organizationId,
    required this.inviterId,
    required this.status,
    this.expiresAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) => _$InvitationFromJson(json);

  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}
