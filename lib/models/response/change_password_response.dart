import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/models/response/user_and_token_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_password_response.g.dart';

@JsonSerializable()
class ChangePasswordResponse extends UserAndTokenResponse {
  ChangePasswordResponse({required super.user, required super.token});
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => _$ChangePasswordResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}
