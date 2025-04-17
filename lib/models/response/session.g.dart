// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: json['id'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  token: json['token'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  ipAddress: json['ipAddress'] as String,
  userAgent: json['userAgent'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'token': instance.token,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'ipAddress': instance.ipAddress,
  'userAgent': instance.userAgent,
  'userId': instance.userId,
};
