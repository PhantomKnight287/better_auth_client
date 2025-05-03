import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final String id;
  final String provider;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({required this.id, required this.provider, required this.createdAt, required this.updatedAt});

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
