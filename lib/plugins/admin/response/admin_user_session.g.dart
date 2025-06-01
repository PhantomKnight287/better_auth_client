// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserSession _$AdminUserSessionFromJson(Map<String, dynamic> json) =>
    AdminUserSession(
      id: json['id'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      token: json['token'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      userId: json['userId'] as String,
      impersonatedBy: json['impersonatedBy'] as String?,
      activeOrganizationId: json['activeOrganizationId'] as String?,
    );
