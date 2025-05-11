import 'package:json_annotation/json_annotation.dart';

part 'two_factor_totp_uri.g.dart';

@JsonSerializable()
class TwoFactorTOTPURI {
  final String totpURI;

  TwoFactorTOTPURI({required this.totpURI});

  factory TwoFactorTOTPURI.fromJson(Map<String, dynamic> json) => _$TwoFactorTOTPURIFromJson(json);

  Map<String, dynamic> toJson() => _$TwoFactorTOTPURIToJson(this);
}
