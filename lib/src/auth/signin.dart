import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/request/id_token.dart';
import 'package:better_auth_client/models/response/social_sign_in_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:dio/dio.dart';

class Signin<T extends User> {
  final Dio _dio;
  final Function(String) _setToken;
  final String? _scheme;
  final T Function(Map<String, dynamic>)? _fromJsonUser;

  Signin({
    required Dio dio,
    required Function(String) setToken,
    String? scheme,
    T Function(Map<String, dynamic>)? fromJsonUser,
  }) : _dio = dio,
       _setToken = setToken,
       _scheme = scheme,
       _fromJsonUser = fromJsonUser;

  /// Sign in with email and password
  ///
  /// [email] The email of the user
  ///
  /// [password] The password of the user
  Future<User> email({required String email, required String password}) async {
    try {
      final response = await _dio.post("/sign-in/email", data: {"email": email, "password": password});
      final body = response.data;
      _setToken(body["token"]);

      // Use custom fromJson if provided, otherwise use default User.fromJson
      final user = User.fromJson(body["user"]);
      _setToken(body["token"]);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with a social provider
  ///
  /// [provider] The social provider to use
  ///
  /// [callbackURL] The callback URL to use. System will automatically prepend the scheme to the URL. So if you want send user to <your-app>://<callback-url>, you should pass <callback-url>
  ///
  /// [newUserCallbackURL] The callback URL to use for new users. System will automatically prepend the scheme to the URL. So if you want send user to <your-app>://<callback-url>, you should pass <callback-url>
  ///
  /// [errorCallbackURL] The callback URL to use for errors. System will automatically prepend the scheme to the URL. So if you want send user to <your-app>://<callback-url>, you should pass <callback-url>
  ///
  /// [idToken] The ID token to use for the social provider. Usually applicable to Apple and Google if you prefer to use native packages to handle the sign in process.
  ///
  /// [scopes] The scopes to use for the social provider. Will override the default scopes for the provider.
  Future<SocialSignInResponse> social({
    required String provider,
    String? callbackURL,
    String? newUserCallbackURL,
    String? errorCallbackURL,
    IdToken? idToken,
    List<String>? scopes,
  }) async {
    try {
      if (_scheme == null) {
        throw Exception("Scheme is not set. Please set the scheme in the BetterAuthClient constructor.");
      }
      final body = {"provider": provider};
      if (callbackURL != null) {
        body["callbackURL"] = "$_scheme$callbackURL";
      }
      final res = await _dio.post('/sign-in/social', data: body, options: Options(headers: {"expo-origin": _scheme}));
      return SocialSignInResponse.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}
