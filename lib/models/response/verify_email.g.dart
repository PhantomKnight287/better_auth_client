// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailResponse _$VerifyEmailResponseFromJson(Map<String, dynamic> json) =>
    VerifyEmailResponse(user: User.fromJson(json['user'] as Map<String, dynamic>), status: json['status'] as bool);

Map<String, dynamic> _$VerifyEmailResponseToJson(VerifyEmailResponse instance) => <String, dynamic>{
  'user': instance.user,
  'status': instance.status,
};
