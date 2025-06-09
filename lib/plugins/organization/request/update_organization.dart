import 'package:json_annotation/json_annotation.dart';

part "update_organization.g.dart";

@JsonSerializable()
class UpdateOrganizationRequest {
  final String? name;
  final String? logo;
  final Map<String, dynamic>? metadata;
  final String? slug;

  UpdateOrganizationRequest({
    this.name,
    this.logo,
    this.metadata,
    this.slug,
  });

  factory UpdateOrganizationRequest.fromJson(Map<String, dynamic> json) => _$UpdateOrganizationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrganizationRequestToJson(this);
}
