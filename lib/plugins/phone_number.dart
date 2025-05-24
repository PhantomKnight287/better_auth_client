import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/status_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/models/response/user_and_token_response.dart';
import 'package:better_auth_client/plugins/base.dart';

class PhoneNumberPlugin<T extends User> extends BasePlugin<T> {
  PhoneNumberPlugin();

  /// Send OTP to phone number
  ///
  /// [phoneNumber] The phone number to send the OTP to
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      await dio.post(
        "/phone-number/send-otp",
        data: {"phoneNumber": phoneNumber},
        options: await getOptions(isTokenRequired: false),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify the phone number of the user
  ///
  /// [phoneNumber] The phone number to verify
  ///
  /// [code] The code to verify sent via [sendOTP]
  ///
  /// [disableSession] Whether to disable the session
  ///
  /// [updatePhoneNumber] Whether to update the phone number
  Future<UserAndTokenResponse> verifyPhoneNumber({
    required String phoneNumber,
    required String code,
    bool? disableSession = false,
    bool? updatePhoneNumber,
  }) async {
    try {
      final response = await dio.post(
        "/phone-number/verify",
        data: {
          "phoneNumber": phoneNumber,
          "code": code,
          "disableSession": disableSession,
          "updatePhoneNumber": updatePhoneNumber,
        },
      );
      return UserAndTokenResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Initiate password forgot flow using phone number
  ///
  /// [phoneNumber] The phone number to initiate the forgot password flow
  Future<StatusResponse> forgotPassword({required String phoneNumber}) async {
    try {
      final response = await dio.post("/phone-number/forgot-password", data: {"phoneNumber": phoneNumber});
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Reset the password of the user
  ///
  /// [otp] The OTP to reset the password
  ///
  /// [phoneNumber] The phone number to reset the password
  ///
  /// [newPassword] The new password to set
  Future<StatusResponse> resetPassword({
    required String otp,
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        "/phone-number/reset-password",
        data: {"otp": otp, "phoneNumber": phoneNumber, "newPassword": newPassword},
      );
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
