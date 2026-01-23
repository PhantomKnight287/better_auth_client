import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/request/id_token.dart';
import 'package:better_auth_client/models/response/status_response.dart';
import 'package:better_auth_client/models/response/user_and_token_response.dart';
import 'package:dio/dio.dart';

class Signin<T extends User> {
  final Dio _dio;
  final Function(String) _setToken;
  final String? _scheme;
  late final T Function(Map<String, dynamic> json) _fromJsonUser;
  late final Future<Options> Function({bool isTokenRequired}) _getOptions;

  Signin({
    required Dio dio,
    required Function(String) setToken,
    String? scheme,
    required T Function(Map<String, dynamic> json) fromJsonUser,
    required Future<Options> Function({bool isTokenRequired}) getOptions,
  }) : _dio = dio,
       _setToken = setToken,
       _scheme = scheme,
       _fromJsonUser = fromJsonUser,
       _getOptions = getOptions;

  /// Sign in with email and password
  ///
  /// [email] The email of the user
  ///
  /// [password] The password of the user
  Future<User> email({String? email, required String password, String? username}) async {
    assert(email != null || username != null, "Either email or username must be provided");
    try {
      final response = await _dio.post(
        "/sign-in/email",
        data: {"email": email, "password": password, "username": username},
        options: await _getOptions(isTokenRequired: false),
      );
      final body = response.data;
      _setToken(body["token"]);

      // Use custom fromJson if provided, otherwise use default User.fromJson
      final user = User.fromJson(body["user"]);
      _setToken(body["token"]);
      return user;
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
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
    List<String>? scopes,
  }) async {
    assert(_scheme != null, "Either idToken or scheme must be provided");
    final body = {"provider": provider};
    if (callbackURL != null) {
      body["callbackURL"] = "$_scheme$callbackURL";
    }
    final baseOptions = await _getOptions(isTokenRequired: false);
    baseOptions.headers ??= {};
    baseOptions.headers!["expo-origin"] = _scheme;
    try {
      final res = await _dio.post('/sign-in/social', data: body, options: baseOptions);
      return SocialSignInResponse.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Sign in with a social provider with id token
  ///
  /// [provider] The social provider to use
  ///
  /// [idToken] The ID token to use for the social provider. Usually applicable to Apple and Google if you prefer to use native packages to handle the sign in process.
  Future<UserAndTokenResponse> socialWithIdToken({required String provider, required IdToken idToken}) async {
    final body = {"provider": provider, "idToken": idToken.toJson()};
    final baseOptions = await _getOptions(isTokenRequired: false);
    baseOptions.headers ??= {};
    if (_scheme != null) {
      baseOptions.headers!["expo-origin"] = _scheme;
    }
    try {
      final res = await _dio.post('/sign-in/social', data: body, options: baseOptions);
      _setToken(res.data['token']);
      return UserAndTokenResponse.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Sign in anonymously
  Future<UserAndTokenResponse> anonymous() async {
    try {
      final response = await _dio.post("/sign-in/anonymous", options: await _getOptions(isTokenRequired: false));
      _setToken(response.data['token']);
      return UserAndTokenResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Sign in with phone number
  ///
  /// [phoneNumber] The phone number of the user
  ///
  /// [password] The password of the user
  ///
  /// [rememberMe] Whether to remember the user
  Future<SessionResponse<T>> phoneNumber({
    required String phoneNumber,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _dio.post(
        "/sign-in/phone-number",
        data: {"phoneNumber": phoneNumber, "password": password, "rememberMe": rememberMe},
        options: await _getOptions(isTokenRequired: false),
      );
      return SessionResponse.fromJson(response.data, _fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Sign in with a magic link
  ///
  /// [email] The email of the user
  ///
  /// [callbackURL] The callback URL to use. System will automatically prepend the scheme to the URL. So if you want send user to <your-app>://<callback-url>, you should pass <callback-url>
  ///
  /// [name] The name of the user
  Future<StatusResponse> magicLink({required String email, String? callbackURL, String? name}) async {
    try {
      final response = await _dio.post(
        "/sign-in/magic-link",
        data: {"email": email, "callbackURL": callbackURL, "name": name},
        options: await _getOptions(isTokenRequired: false),
      );
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Sign in with email OTP
  ///
  /// [email] The email of the user
  ///
  /// [otp] The OTP of the user
  Future<UserAndTokenResponse> emailOtp({required String email, required String otp}) async {
    try {
      final response = await _dio.post(
        "/sign-in/email-otp",
        data: {"email": email, "otp": otp},
        options: await _getOptions(isTokenRequired: false),
      );
      return UserAndTokenResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
