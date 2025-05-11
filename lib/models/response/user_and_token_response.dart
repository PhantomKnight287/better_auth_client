import 'package:better_auth_client/models/response/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_and_token_response.g.dart';

@JsonSerializable()
class UserAndTokenResponse {
  final User user;
  final String token;

  UserAndTokenResponse({required this.user, required this.token});

  factory UserAndTokenResponse.fromJson(Map<String, dynamic> json) => _$UserAndTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserAndTokenResponseToJson(this);
}
