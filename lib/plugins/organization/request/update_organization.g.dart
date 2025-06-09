// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrganizationRequest _$UpdateOrganizationRequestFromJson(
  Map<String, dynamic> json,
) => UpdateOrganizationRequest(
  name: json['name'] as String?,
  logo: json['logo'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$UpdateOrganizationRequestToJson(
  UpdateOrganizationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'logo': instance.logo,
  'metadata': instance.metadata,
  'slug': instance.slug,
};
