import 'package:better_auth_client/models/response/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_email.g.dart';

@JsonSerializable()
class VerifyEmailResponse {
  final User user;
  final bool status;

  VerifyEmailResponse({required this.user, required this.status});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) => _$VerifyEmailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyEmailResponseToJson(this);
}
