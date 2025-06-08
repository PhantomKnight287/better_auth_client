import 'package:better_auth_client/plugins/organization/response/organization.dart';
import 'package:json_annotation/json_annotation.dart';

part "create_organization.g.dart";

@JsonSerializable()
class CreateOrganizationResponse extends Organization {
  CreateOrganizationResponse({
    required super.id,
    required super.name,
    required super.logo,
    required super.createdAt,
    required super.slug,
    required super.metadata,
  });

  factory CreateOrganizationResponse.fromJson(Map<String, dynamic> json) => _$CreateOrganizationResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CreateOrganizationResponseToJson(this);
}
