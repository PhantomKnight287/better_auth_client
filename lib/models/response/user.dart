import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  final String email;
  final String name;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isEmailVerified;

  /// Custom properties that don't fit in the standard model
  final Map<String, dynamic> customProperties;

  User({required this.id, required this.email, required this.name, this.image, required this.createdAt, required this.updatedAt, this.isEmailVerified, Map<String, dynamic>? customProperties})
    : this.customProperties = customProperties ?? {};

  factory User.fromJson(Map<String, dynamic> json) {
    // Create a copy of the json to avoid modifying the original
    final jsonCopy = Map<String, dynamic>.from(json);

    // Remove standard fields so we can collect the remaining as custom properties
    final standardFields = ['id', 'email', 'name', 'image', 'createdAt', 'updatedAt', 'isEmailVerified'];
    final customProps = Map<String, dynamic>.fromEntries(jsonCopy.entries.where((entry) => !standardFields.contains(entry.key)));

    // Add custom properties to json so it gets included in the generated model
    jsonCopy['customProperties'] = customProps;

    return _$UserFromJson(jsonCopy);
  }

  Map<String, dynamic> toJson() {
    final json = _$UserToJson(this);

    // Add custom properties to the top level
    json.addAll(customProperties);

    // Remove the customProperties field from the result
    json.remove('customProperties');

    return json;
  }

  // Get a custom property with type safety
  T? getCustomProperty<T>(String key) {
    final value = customProperties[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  @override
  String toString() {
    return "User(id: $id, email: $email, name: $name, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isEmailVerified: $isEmailVerified, customProperties: $customProperties)";
  }
}
