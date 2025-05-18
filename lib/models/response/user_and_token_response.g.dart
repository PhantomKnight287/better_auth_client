// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_and_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAndTokenResponse _$UserAndTokenResponseFromJson(
  Map<String, dynamic> json,
) => UserAndTokenResponse(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
);

Map<String, dynamic> _$UserAndTokenResponseToJson(
  UserAndTokenResponse instance,
) => <String, dynamic>{'user': instance.user, 'token': instance.token};
