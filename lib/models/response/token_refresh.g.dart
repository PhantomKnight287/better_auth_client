// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_refresh.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenRefresh _$TokenRefreshFromJson(Map<String, dynamic> json) => TokenRefresh(
  tokenType: json['tokenType'] as String,
  idToken: json['idToken'] as String,
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessTokenExpiresAt: DateTime.parse(json['accessTokenExpiresAt'] as String),
  refreshTokenExpiresAt: DateTime.parse(json['refreshTokenExpiresAt'] as String),
);

Map<String, dynamic> _$TokenRefreshToJson(TokenRefresh instance) => <String, dynamic>{
  'tokenType': instance.tokenType,
  'idToken': instance.idToken,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'accessTokenExpiresAt': instance.accessTokenExpiresAt.toIso8601String(),
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt.toIso8601String(),
};
