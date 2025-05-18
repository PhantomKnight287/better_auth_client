import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/plugins/base.dart';
import 'package:better_auth_client/plugins/one_time_token/response/generate_token.dart';

class OneTimeTokenPlugin<T extends User> extends BasePlugin<T> {
  OneTimeTokenPlugin({
    required super.dio,
    required super.fromJsonUser,
    required super.getOptions,
    required super.setToken,
  });

  /// Generate a one time token
  Future<GenerateTokenResponse> generateToken() async {
    try {
      final res = await dio.get("/one-time-token/generate", options: await getOptions(isTokenRequired: true));
      return GenerateTokenResponse.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify a one time token
  ///
  /// [token] is the one time token to verify
  ///
  Future<SessionResponse<T>> verifyToken({required String token}) async {
    try {
      final res = await dio.post(
        "/one-time-token/verify",
        data: {"token": token},
        options: await getOptions(isTokenRequired: true),
      );
      return SessionResponse<T>.fromJson(res.data, fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
