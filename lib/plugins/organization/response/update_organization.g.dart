// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrganizationResponse _$UpdateOrganizationResponseFromJson(
  Map<String, dynamic> json,
) => UpdateOrganizationResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  logo: json['logo'] as String,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  slug: json['slug'] as String,
  metadata: json['metadata'] as Map<String, dynamic>,
);

Map<String, dynamic> _$UpdateOrganizationResponseToJson(
  UpdateOrganizationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'createdAt': instance.createdAt?.toIso8601String(),
  'slug': instance.slug,
  'metadata': instance.metadata,
};
