import 'package:json_annotation/json_annotation.dart';

part 'social_sign_in_response.g.dart';

@JsonSerializable()
class SocialSignInResponse {
  final String url;
  final bool redirect;

  const SocialSignInResponse({required this.url, required this.redirect});

  factory SocialSignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SocialSignInResponseFromJson(json);

  toJson() => _$SocialSignInResponseToJson(this);
}
