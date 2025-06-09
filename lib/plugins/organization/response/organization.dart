import 'package:json_annotation/json_annotation.dart';

part "organization.g.dart";

@JsonSerializable()
class Organization {
  final String id;
  final String name;
  final String logo;
  final DateTime? createdAt;
  final String slug;
  final Map<String, dynamic> metadata;

  Organization({
    required this.id,
    required this.name,
    required this.logo,
    required this.createdAt,
    required this.slug,
    required this.metadata,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
