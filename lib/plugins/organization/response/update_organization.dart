import 'package:better_auth_client/plugins/organization/response/organization.dart';
import 'package:json_annotation/json_annotation.dart';

part "update_organization.g.dart";

@JsonSerializable()
class UpdateOrganizationResponse extends Organization {
  UpdateOrganizationResponse({
    required super.id,
    required super.name,
    required super.logo,
    required super.createdAt,
    required super.slug,
    required super.metadata,
  });

  factory UpdateOrganizationResponse.fromJson(Map<String, dynamic> json) => _$UpdateOrganizationResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UpdateOrganizationResponseToJson(this);
}
