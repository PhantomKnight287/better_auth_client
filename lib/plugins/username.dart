import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/plugins/base.dart';

/// Username plugin for better-auth.
///
/// Requires [username] plugin to be installed server side.
///
/// This plugin allows users to sign in using their username and password
/// instead of email and password.
class UsernamePlugin<T extends User> extends BasePlugin<T> {
  UsernamePlugin();

  /// Sign in with username and password
  ///
  /// [username] The username of the user
  ///
  /// [password] The password of the user
  ///
  /// [rememberMe] Whether to remember the user
  Future<SessionResponse<T>> signIn({
    required String username,
    required String password,
    bool? rememberMe,
  }) async {
    try {
      final response = await dio.post(
        "/sign-in/username",
        data: {
          "username": username,
          "password": password,
          if (rememberMe != null) "rememberMe": rememberMe,
        },
        options: await getOptions(isTokenRequired: false),
      );
      final body = response.data;
      await tokenStore.saveToken(body["token"]);
      return SessionResponse.fromJson(body, fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
