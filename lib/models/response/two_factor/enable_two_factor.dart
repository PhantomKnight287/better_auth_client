import 'package:better_auth_client/models/response/two_factor/two_factor_totp_uri.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enable_two_factor.g.dart';

@JsonSerializable()
class EnableTwoFactorResponse extends TwoFactorTOTPURI {
  final List<String> backupCodes;

  EnableTwoFactorResponse({required super.totpURI, required this.backupCodes});

  factory EnableTwoFactorResponse.fromJson(Map<String, dynamic> json) => _$EnableTwoFactorResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EnableTwoFactorResponseToJson(this);
}
