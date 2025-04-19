import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isEmailVerified;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "User(id: $id, email: $email, name: $name, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isEmailVerified: $isEmailVerified)";
  }
}
