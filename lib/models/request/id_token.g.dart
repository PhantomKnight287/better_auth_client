// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdToken _$IdTokenFromJson(Map<String, dynamic> json) => IdToken(
  token: json['token'] as String,
  nonce: json['nonce'] as String?,
  accessToken: json['accessToken'] as String?,
);

Map<String, dynamic> _$IdTokenToJson(IdToken instance) => <String, dynamic>{
  'token': instance.token,
  if (instance.nonce case final value?) 'nonce': value,
  if (instance.accessToken case final value?) 'accessToken': value,
};
