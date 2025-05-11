import 'package:better_auth_client/models/response/status_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'two_factor_verify_totp.g.dart';

@JsonSerializable()
class TwoFactorVerifyTotp extends StatusResponse {
  TwoFactorVerifyTotp({required super.status});

  factory TwoFactorVerifyTotp.fromJson(Map<String, dynamic> json) => _$TwoFactorVerifyTotpFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TwoFactorVerifyTotpToJson(this);
}
