import 'package:json_annotation/json_annotation.dart';

part 'id_token.g.dart';

@JsonSerializable()
class IdToken {
  final String token;
  final String? nonce;
  final String? accessToken;

  IdToken({required this.token, this.nonce, this.accessToken});

  factory IdToken.fromJson(Map<String, dynamic> json) =>
      _$IdTokenFromJson(json);

  Map<String, dynamic> toJson() => _$IdTokenToJson(this);
}
