// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  emailVerified: json['emailVerified'] as bool?,
  twoFactorEnabled: json['twoFactorEnabled'] as bool?,
  username: json['username'] as String?,
  displayUsername: json['displayUsername'] as String?,
  isAnonymous: json['isAnonymous'] as bool?,
  phoneNumber: json['phoneNumber'] as String?,
  phoneNumberVerified: json['phoneNumberVerified'] as bool?,
  role: json['role'] as String?,
  banned: json['banned'] as bool?,
  banReason: json['banReason'] as String?,
  banExpires:
      json['banExpires'] == null
          ? null
          : DateTime.parse(json['banExpires'] as String),
  customProperties: json['customProperties'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'image': instance.image,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'emailVerified': instance.emailVerified,
  'twoFactorEnabled': instance.twoFactorEnabled,
  'username': instance.username,
  'displayUsername': instance.displayUsername,
  'isAnonymous': instance.isAnonymous,
  'phoneNumber': instance.phoneNumber,
  'phoneNumberVerified': instance.phoneNumberVerified,
  'role': instance.role,
  'banned': instance.banned,
  'banReason': instance.banReason,
  'banExpires': instance.banExpires?.toIso8601String(),
  'customProperties': instance.customProperties,
};
