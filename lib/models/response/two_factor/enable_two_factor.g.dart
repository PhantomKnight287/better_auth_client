// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enable_two_factor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnableTwoFactorResponse _$EnableTwoFactorResponseFromJson(Map<String, dynamic> json) => EnableTwoFactorResponse(
  totpURI: json['totpURI'] as String,
  backupCodes: (json['backupCodes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$EnableTwoFactorResponseToJson(EnableTwoFactorResponse instance) => <String, dynamic>{
  'totpURI': instance.totpURI,
  'backupCodes': instance.backupCodes,
};
