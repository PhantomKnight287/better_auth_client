import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/plugins/base.dart';

class MagicLinkPlugin<T extends User> extends BasePlugin<T> {
  MagicLinkPlugin();

  Future<SessionResponse<T>> verify({required String token, String? callbackURL}) async {
    try {
      final response = await dio.post(
        "/magic-link/verify?token=$token&callbackURL=$callbackURL",
        options: await getOptions(isTokenRequired: false),
      );
      return SessionResponse.fromJson(response.data, fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
