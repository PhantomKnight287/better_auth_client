import 'package:better_auth_client/models/response/user.dart';

/// A base class that allows you to extend the User model with custom properties
abstract class ExtendableUser extends User {
  ExtendableUser({required super.id, required super.email, required super.name, super.image, required super.createdAt, required super.updatedAt, super.isEmailVerified});

  /// Factory method to create a specific user type from json
  /// Override this in your custom user class
  static User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

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
  ///     super.isEmailVerified,
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
  ///       isEmailVerified: json['isEmailVerified'],
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
}
