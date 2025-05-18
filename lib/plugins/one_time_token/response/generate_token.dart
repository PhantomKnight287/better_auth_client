import 'package:json_annotation/json_annotation.dart';

part 'generate_token.g.dart';

@JsonSerializable(createToJson: false)
class GenerateTokenResponse {
  /// The one time token
  ///
  /// Usually expires in 3 minutes, unless specified otherwise in the server configuration
  final String token;

  GenerateTokenResponse({required this.token});

  factory GenerateTokenResponse.fromJson(Map<String, dynamic> json) => _$GenerateTokenResponseFromJson(json);
}
