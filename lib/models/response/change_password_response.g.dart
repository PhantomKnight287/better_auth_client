// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponse _$ChangePasswordResponseFromJson(Map<String, dynamic> json) =>
    ChangePasswordResponse(user: User.fromJson(json['user'] as Map<String, dynamic>), token: json['token'] as String);

Map<String, dynamic> _$ChangePasswordResponseToJson(ChangePasswordResponse instance) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
};
