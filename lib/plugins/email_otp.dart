import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/success_response.dart';
import 'package:better_auth_client/models/response/user_and_token_response.dart';
import 'package:better_auth_client/plugins/base.dart';

class EmailOtpPlugin<T extends User> extends BasePlugin<T> {
  EmailOtpPlugin({required super.dio, required super.fromJsonUser, required super.getOptions, required super.setToken});

  /// Send verification OTP to email address of the user
  ///
  /// [email] The email address of the user
  ///
  /// [type] The type of the OTP. Can be either "sign-in", "email-verification" or "forget-password"
  Future<SuccessResponse> sendVerificationOTP({required String email, required String type}) async {
    try {
      final response = await dio.post(
        "/email-otp/send-verification-otp",
        data: {"email": email, "type": type},
        options: await getOptions(isTokenRequired: false),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify email OTP
  ///
  /// [email] The email address of the user
  ///
  /// [otp] The OTP sent to the user's email
  Future<UserAndTokenResponse> verifyEmail({required String email, required String otp}) async {
    try {
      final response = await dio.post("/email-otp/verify-email", data: {"email": email, "otp": otp});
      return UserAndTokenResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Reset password using email OTP
  ///
  /// [email] The email address of the user
  ///
  /// [otp] The OTP sent to the user's email
  ///
  /// [password] The new password of the user
  Future<SuccessResponse> resetPassword({required String email, required String otp, required String password}) async {
    try {
      final response = await dio.post(
        "/email-otp/reset-password",
        data: {"email": email, "otp": otp, "password": password},
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Start the forget password flow using email OTP
  ///
  /// [email] The email address of the user
  Future<SuccessResponse> forgetPassword({required String email}) async {
    try {
      final response = await dio.post("/email-otp/forget-password", data: {"email": email});
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
