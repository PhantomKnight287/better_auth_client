import 'package:better_auth_client/models/response/user.dart';

/// A base class that allows you to extend the User model with custom properties
///
/// Example of how to extend this class:
///
/// ```dart
/// class CustomUser extends ExtendableUser {
///   final String customField;
///
///   CustomUser({
///     required super.id,
///     required super.email,
///     required super.name,
///     super.image,
///     required super.createdAt,
///     required super.updatedAt,
///     super.emailVerified,
///     super.twoFactorEnabled,
///     super.username,
///     super.displayUsername,
///     super.isAnonymous,
///     super.phoneNumber,
///     super.phoneNumberVerified,
///     required this.customField,
///   });
///
///   factory CustomUser.fromJson(Map<String, dynamic> json) {
///     return CustomUser(
///       id: json['id'],
///       email: json['email'],
///       name: json['name'],
///       image: json['image'],
///       createdAt: DateTime.parse(json['createdAt']),
///       updatedAt: DateTime.parse(json['updatedAt']),
///       emailVerified: json['emailVerified'],
///       twoFactorEnabled: json['twoFactorEnabled'],
///       username: json['username'],
///       displayUsername: json['displayUsername'],
///       isAnonymous: json['isAnonymous'],
///       phoneNumber: json['phoneNumber'],
///       phoneNumberVerified: json['phoneNumberVerified'],
///       customField: json['customField'],
///     );
///   }
///
///   @override
///   Map<String, dynamic> toJson() {
///     final json = super.toJson();
///     json['customField'] = customField;
///     return json;
///   }
/// }
/// ```
abstract class ExtendableUser extends User {
  ExtendableUser({
    required super.id,
    required super.email,
    required super.name,
    super.image,
    required super.createdAt,
    required super.updatedAt,
    super.emailVerified,
    super.twoFactorEnabled,
    super.username,
    super.displayUsername,
    super.isAnonymous,
    super.phoneNumber,
    super.phoneNumberVerified,
    super.banExpires,
    super.banReason,
    super.banned,
    super.customProperties,
    super.role,
  });

  /// Factory method to create a specific user type from json
  /// Override this in your custom user class
  static User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
