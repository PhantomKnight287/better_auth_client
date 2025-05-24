// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => ApiKey(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  name: json['name'] as String?,
  prefix: json['prefix'] as String?,
  start: json['start'] as String?,
  key: json['key'] as String?,
  enabled: json['enabled'] as bool?,
  expiresAt: json['expiresAt'] as String?,
  userId: json['userId'] as String?,
  lastRefillAt: json['lastRefillAt'] as String?,
  lastRequest: json['lastRequest'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  rateLimitMax: (json['rateLimitMax'] as num?)?.toInt(),
  rateLimitTimeWindow: (json['rateLimitTimeWindow'] as num?)?.toInt(),
  remaining: (json['remaining'] as num?)?.toInt(),
  refillAmount: (json['refillAmount'] as num?)?.toInt(),
  refillInterval: (json['refillInterval'] as num?)?.toInt(),
  rateLimitEnabled: json['rateLimitEnabled'] as bool?,
  requestCount: (json['requestCount'] as num?)?.toInt(),
  permissions: (json['permissions'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
);

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'name': instance.name,
  'prefix': instance.prefix,
  'start': instance.start,
  'key': instance.key,
  'enabled': instance.enabled,
  'expiresAt': instance.expiresAt,
  'userId': instance.userId,
  'lastRefillAt': instance.lastRefillAt,
  'lastRequest': instance.lastRequest,
  'metadata': instance.metadata,
  'rateLimitMax': instance.rateLimitMax,
  'rateLimitTimeWindow': instance.rateLimitTimeWindow,
  'remaining': instance.remaining,
  'refillAmount': instance.refillAmount,
  'refillInterval': instance.refillInterval,
  'rateLimitEnabled': instance.rateLimitEnabled,
  'requestCount': instance.requestCount,
  'permissions': instance.permissions,
};
