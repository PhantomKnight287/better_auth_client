// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_user_sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserSessionsResponse _$ListUserSessionsResponseFromJson(
  Map<String, dynamic> json,
) => ListUserSessionsResponse(
  sessions:
      (json['sessions'] as List<dynamic>)
          .map((e) => AdminUserSession.fromJson(e as Map<String, dynamic>))
          .toList(),
);
