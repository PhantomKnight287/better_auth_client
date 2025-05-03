// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionResponse<T> _$SessionResponseFromJson<T extends User>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => SessionResponse<T>(
  session: Session.fromJson(json['session'] as Map<String, dynamic>),
  user: fromJsonT(json['user']),
);

Map<String, dynamic> _$SessionResponseToJson<T extends User>(
  SessionResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'session': instance.session, 'user': toJsonT(instance.user)};
