// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrganizationResponse _$CreateOrganizationResponseFromJson(
  Map<String, dynamic> json,
) => CreateOrganizationResponse(
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

Map<String, dynamic> _$CreateOrganizationResponseToJson(
  CreateOrganizationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'createdAt': instance.createdAt?.toIso8601String(),
  'slug': instance.slug,
  'metadata': instance.metadata,
};
