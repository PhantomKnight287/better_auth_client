import 'package:better_auth_client/models/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:better_auth_client/models/signup.dart';
import 'package:better_auth_client/networking/main.dart';
import 'package:better_auth_client/networking/response.dart';
import 'package:dio/dio.dart';

/// Create a better auth client
class BetterAuthClient {
  /// The base url where your better auth is running. Do not add trailing slash.
  /// example: http://10.0.2.2:3000/api/auth
  final String baseUrl;

  /// The token store to save and retrieve the token.
  ///
  /// You can implement your own token store by extending the [TokenStore] class.
  final TokenStore tokenStore;

  /// The Deep Link scheme of your app
  /// This will be used to open the callback urls
  String? scheme;
  late final Signup signUp;
  late final Signin signIn;
  late final Dio dio;

  BetterAuthClient({
    required this.baseUrl,
    required this.tokenStore,
    this.scheme,
  }) {
    _internal();
  }

  void _internal() {
    dio = generateDioClient(baseUrl);
    signUp = Signup(dio: dio, setToken: tokenStore.saveToken);
    signIn = Signin(dio: dio, setToken: tokenStore.saveToken, scheme: scheme);
  }

  /// Sign out the user. This calls [TokenStore.saveToken] with null.
  Future<BetterAuthClientResponse<void, Exception>> signOut() async {
    try {
      await tokenStore.saveToken(null);
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Send a verification email to the user.
  Future<BetterAuthClientResponse<void, Exception>> sendVerificationEmail(
    String email, {
    String? callbackURL,
  }) async {
    try {
      await dio.post(
        "$baseUrl/send-verification-email",
        data: {"email": email, "callbackURL": callbackURL},
      );
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Send a forgot password email to the user.
  Future<BetterAuthClientResponse<void, Exception>> forgetPassword(
    String email, {
    String? callbackURL,
  }) async {
    try {
      await dio.post(
        "$baseUrl/forget-password",
        data: {"email": email, "callbackURL": callbackURL},
      );
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Reset the password of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  Future<BetterAuthClientResponse<void, Exception>> resetPassword(
    String token,
    String newPassword,
  ) async {
    try {
      await dio.post(
        "$baseUrl/reset-password",
        data: {"token": token, "newPassword": newPassword},
      );
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
