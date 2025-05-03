import 'package:json_annotation/json_annotation.dart';

part 'token_refresh.g.dart';

@JsonSerializable()
class TokenRefresh {
  final String tokenType;
  final String idToken;
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;

  TokenRefresh({
    required this.tokenType,
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
  });

  factory TokenRefresh.fromJson(Map<String, dynamic> json) => _$TokenRefreshFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRefreshToJson(this);
}
