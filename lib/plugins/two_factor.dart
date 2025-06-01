import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/status_response.dart';
import 'package:better_auth_client/models/response/two_factor/enable_two_factor.dart';
import 'package:better_auth_client/models/response/two_factor/generate_backup_codes.dart';
import 'package:better_auth_client/models/response/two_factor/two_factor_totp_uri.dart';
import 'package:better_auth_client/models/response/two_factor/two_factor_verify_totp.dart';
import 'package:better_auth_client/models/response/user_and_token_response.dart';
import 'package:better_auth_client/plugins/base.dart';

class TwoFactorPlugin<T extends User> extends BasePlugin<T> {
  TwoFactorPlugin();

  /// Get TOTP URI
  ///
  /// [password] The password of the user
  Future<TwoFactorTOTPURI> getTotpUri({required String password}) async {
    try {
      final response = await dio.post(
        "/two-factor/get-totp-uri",
        data: {"password": password},
        options: await super.getOptions(),
      );
      return TwoFactorTOTPURI.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify TOTP
  ///
  /// [code] The TOTP code
  /// [trustDevice] If true, the device will be trusted for 30 days. It'll be refreshed on every sign in request within this time.
  Future<StatusResponse> verifyTotp({required String code, bool trustDevice = false}) async {
    try {
      final response = await dio.post(
        "/two-factor/verify-totp",
        data: {"code": code, "trustDevice": trustDevice},
        options: await super.getOptions(),
      );
      return TwoFactorVerifyTotp.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Send two factor OTP to the user
  Future<StatusResponse> sendOtp() async {
    try {
      final response = await dio.post("/two-factor/send-otp", options: await super.getOptions());
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify two factor OTP
  ///
  /// [code] The OTP code
  /// [trustDevice] If true, the device will be trusted for 30 days. It'll be refreshed on every sign in request within this time.
  Future<UserAndTokenResponse> verifyOtp({required String code, bool trustDevice = false}) async {
    try {
      final response = await dio.post(
        "/two-factor/verify-otp",
        data: {"code": code, "trustDevice": trustDevice},
        options: await super.getOptions(),
      );
      final responseData = UserAndTokenResponse.fromJson(response.data);
      await super.tokenStore.saveToken(responseData.token);
      return responseData;
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify backup code
  ///
  /// [code] The backup code
  /// [trustDevice] If true, the device will be trusted for 30 days. It'll be refreshed on every sign in request within this time.
  /// [disableSession] If true, the session cookie will not be set.
  Future<SessionResponse<User>> verifyBackUpCode({
    required String code,
    bool trustDevice = false,
    bool disableSession = false,
  }) async {
    try {
      final response = await dio.post(
        "/two-factor/verify-backup-code",
        data: {"code": code, "trustDevice": trustDevice, "disableSession": disableSession},
        options: await super.getOptions(),
      );
      return SessionResponse.fromJson(response.data, User.fromJson);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Generate backup codes
  Future<GenerateBackupCodes> generateBackupCodes() async {
    try {
      final response = await dio.post("/two-factor/generate-backup-codes", options: await super.getOptions());
      return GenerateBackupCodes.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Enable two factor
  /// This will generate a TOTP URI and backup codes. Once the user verifies the TOTP URI, the two factor authentication will be enabled.
  ///
  /// [password] The password of the user
  /// [issuer] Custom issuer for the TOTP URI
  Future<EnableTwoFactorResponse> enableTwoFactor({required String password, String? issuer}) async {
    try {
      final response = await dio.post(
        "/two-factor/enable",
        data: {"password": password, "issuer": issuer},
        options: await super.getOptions(),
      );
      return EnableTwoFactorResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Disable two factor
  /// This will disable the two factor authentication and delete the backup codes.
  ///
  /// [password] The password of the user
  Future<StatusResponse> disableTwoFactor({required String password}) async {
    try {
      final response = await dio.post(
        "/two-factor/disable",
        data: {"password": password},
        options: await super.getOptions(),
      );
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
