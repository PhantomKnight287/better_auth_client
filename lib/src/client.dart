// ignore_for_file: avoid_returning_null_for_void

import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/account.dart';
import 'package:better_auth_client/models/response/base_response.dart';
import 'package:better_auth_client/models/response/change_password_response.dart';
import 'package:better_auth_client/models/response/session.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:better_auth_client/models/response/social_sign_in_response.dart';
import 'package:better_auth_client/models/response/token_refresh.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/models/response/verify_email.dart';
import 'package:better_auth_client/plugins/admin/main.dart';
import 'package:better_auth_client/plugins/api_key/main.dart';
import 'package:better_auth_client/plugins/base.dart';
import 'package:better_auth_client/plugins/email_otp.dart';
import 'package:better_auth_client/plugins/magic_link.dart';
import 'package:better_auth_client/plugins/one_time_token/main.dart';
import 'package:better_auth_client/plugins/phone_number.dart';
import 'package:better_auth_client/plugins/two_factor.dart';
import 'package:better_auth_client/src/auth/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:better_auth_client/src/auth/signup.dart';
import 'package:better_auth_client/networking/main.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class StoredCookie {
  final String value;
  final DateTime? expires;

  StoredCookie({required this.value, this.expires});

  Map<String, dynamic> toJson() => {'value': value, 'expires': expires?.toIso8601String()};

  factory StoredCookie.fromJson(Map<String, dynamic> json) =>
      StoredCookie(value: json['value'], expires: json['expires'] != null ? DateTime.parse(json['expires']) : null);
}

/// Create a better auth client
class BetterAuthClient<T extends User> {
  /// The base url where your better auth is running. Do not add trailing slash.
  ///
  /// example: http://10.0.2.2:3000/api/auth
  final String baseUrl;

  /// The token store to save and retrieve the token.
  ///
  /// You can implement your own token store by extending the [TokenStore] class.
  final TokenStore tokenStore;

  /// The Deep Link scheme of your app
  /// This will be used to open the callback urls
  String? scheme;

  /// The signup object
  late final Signup<T> signUp;

  /// The signin object
  late final Signin<T> signIn;
  late final Dio _dio;

  /// Two-Factor Authentication (2FA) plugin.
  ///
  /// Requires [twoFactor] plugin to be installed server side
  late final TwoFactorPlugin<T> twoFactor;

  /// The phone number plugin
  ///
  /// Requires [phoneNumber] plugin to be installed server side
  late final PhoneNumberPlugin<T> phoneNumber;

  /// The magic link plugin
  ///
  /// Requires [magicLink] plugin to be installed server side
  late final MagicLinkPlugin<T> magicLink;

  /// The email OTP plugin
  ///
  /// Requires [emailOtp] plugin to be installed server side
  late final EmailOtpPlugin<T> emailOtp;

  /// The One-Time Token (OTT) plugin provides functionality to generate and verify secure, single-use session tokens. These are commonly used for across domains authentication.
  ///
  /// Requires [oneTimeToken] plugin to be installed server side
  late final OneTimeTokenPlugin<T> oneTimeToken;

  /// The API Key plugin
  ///
  /// Requires [apiKey] plugin to be installed server side
  late final ApiKeyPlugin apiKey;

  /// The Admin plugin
  ///
  /// Requires [admin] plugin to be installed server side
  late final AdminPlugin<T> admin;

  /// Function to convert JSON to a custom user model
  /// If not provided, the default User.fromJson will be used
  final T Function(Map<String, dynamic>) _fromJsonUser;

  /// The custom plugins to be used
  final List<BasePlugin<T>> _customPlugins;

  BetterAuthClient({
    required this.baseUrl,
    required this.tokenStore,
    this.scheme,
    T Function(Map<String, dynamic>)? fromJsonUser,
    List<BasePlugin<T>>? customPlugins,
  }) : _fromJsonUser = fromJsonUser ?? User.fromJson as T Function(Map<String, dynamic>),
       _customPlugins = customPlugins ?? [] {
    _internal();
  }

  void _internal() {
    _dio = generateDioClient(baseUrl);
    signUp = Signup<T>(dio: _dio, setToken: tokenStore.saveToken, fromJsonUser: _fromJsonUser);
    signIn = Signin<T>(
      dio: _dio,
      setToken: tokenStore.saveToken,
      scheme: scheme,
      fromJsonUser: _fromJsonUser,
      getOptions: _getOptions,
    );

    // Initialize built-in plugins
    twoFactor =
        TwoFactorPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    phoneNumber =
        PhoneNumberPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    magicLink =
        MagicLinkPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    emailOtp =
        EmailOtpPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    oneTimeToken =
        OneTimeTokenPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    apiKey =
        ApiKeyPlugin()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    admin =
        AdminPlugin<T>()
          ..initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    // Initialize custom plugins
    for (final plugin in _customPlugins) {
      plugin.initialize(
        dio: _dio,
        getOptions: _getOptions,
        tokenStore: tokenStore,
        fromJsonUser: _fromJsonUser,
      );
    }
  }

  /// Register a custom plugin
  ///
  /// This is useful if you want to use a custom plugin that is not supported by this package.
  /// The plugin will be initialized with the necessary internal values.
  ///
  /// [plugin] is the plugin instance to register
  void registerCustomPlugin<P extends BasePlugin<T>>(P plugin) {
    // Initialize the plugin with internal values
    plugin.initialize(dio: _dio, getOptions: _getOptions, tokenStore: tokenStore, fromJsonUser: _fromJsonUser);
    _customPlugins.add(plugin);
  }

  /// Retrieve a custom plugin instance
  ///
  /// Returns the plugin instance of type P if it exists, otherwise throws an error.
  /// Similar to Provider.of<P>() pattern.
  ///
  /// Example:
  /// ```dart
  /// final myPlugin = client.getCustomPlugin<MyCustomPlugin>();
  /// ```
  P getCustomPlugin<P extends BasePlugin<T>>() {
    try {
      return _customPlugins.firstWhere((plugin) => plugin is P) as P;
    } catch (e) {
      throw Exception('Plugin of type $P not found. Make sure to register it first using registerCustomPlugin.');
    }
  }

  /// Get the options for the request
  Future<Options> _getOptions({bool isTokenRequired = true}) async {
    final token = await tokenStore.getToken();
    if (isTokenRequired) {
      assert(token.isNotEmpty, "Token is not set");
      return Options(headers: {"Authorization": "Bearer $token"});
    }
    return Options();
  }

  /// Sign out the user. This calls [TokenStore.saveToken] with null.
  Future<void> signOut() async {
    try {
      await _dio.post('/sign-out', options: await _getOptions());
      await tokenStore.saveToken(null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Send a verification email to the user.
  Future<void> sendVerificationEmail(String email, {String? callbackURL}) async {
    try {
      await _dio.post("/send-verification-email", data: {"email": email, "callbackURL": callbackURL});
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Send a forgot password email to the user.
  Future<void> forgetPassword(String email, {String? callbackURL}) async {
    try {
      await _dio.post("/forget-password", data: {"email": email, "callbackURL": callbackURL});
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Reset the password of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _dio.post(
        "/reset-password",
        data: {"token": token, "newPassword": newPassword},
        options: await _getOptions(),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Parse cookies from a redirect URL and update the token store
  Future<void> parseCookiesFromRedirectURL(Uri url) async {
    final cookie = url.queryParameters['cookie'];
    if (cookie != null) {
      // Parse the cookie string into a map of cookie attributes
      final cookieMap = _parseSetCookieHeader(cookie);

      // Convert to StoredCookie format
      final storedCookies = <String, StoredCookie>{};
      cookieMap.forEach((name, attributes) {
        final expires =
            attributes['expires'] != null
                ? DateTime.parse(attributes['expires']!)
                : attributes['max-age'] != null
                ? DateTime.now().add(Duration(seconds: int.parse(attributes['max-age']!)))
                : null;

        storedCookies[name] = StoredCookie(value: attributes['value']!, expires: expires);
      });

      // Save the cookies to token store
      await tokenStore.saveToken(jsonEncode(storedCookies));
    }
  }

  Map<String, Map<String, String>> _parseSetCookieHeader(String header) {
    final cookieMap = <String, Map<String, String>>{};
    final cookies = header.split(', ');

    for (final cookie in cookies) {
      final parts = cookie.split('; ');
      final nameValue = parts[0].split('=');
      final name = nameValue[0];
      final value = nameValue[1];

      final attributes = <String, String>{'value': value};

      for (var i = 1; i < parts.length; i++) {
        final attr = parts[i].split('=');
        final attrName = attr[0].toLowerCase();
        final attrValue = attr.length > 1 ? attr[1] : '';
        attributes[attrName] = attrValue;
      }

      cookieMap[name] = attributes;
    }

    return cookieMap;
  }

  /// Get the session of the user.
  ///
  /// Calls [TokenStore.getToken] to get the token and adds it to the request headers.
  ///
  /// Requires Bearer Plugin to be installed
  Future<SessionResponse<T>> getSession() async {
    try {
      final response = await _dio.get("/get-session", options: await _getOptions());
      return SessionResponse.fromJson(response.data, _fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Verify the email of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  ///
  /// [callbackURL] is the URL to redirect to after the email is verified.
  Future<VerifyEmailResponse> verifyEmail({required String token, String? callbackURL}) async {
    try {
      final response = await _dio.post("/verify-email", queryParameters: {"token": token, "callbackURL": callbackURL});
      return VerifyEmailResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Change the email of the user.
  ///
  /// [newEmail] is the new email of the user.
  ///
  /// [callbackURL] is the URL to redirect to after the email is changed.
  Future<BaseResponseWithMessage> changeEmail({required String newEmail, String? callbackURL}) async {
    try {
      final response = await _dio.post(
        "/change-email",
        data: {"newEmail": newEmail, "callbackURL": callbackURL},
        options: await _getOptions(),
      );
      return BaseResponse.fromJson(
        response.data,
        (json) => (json as Map<String, dynamic>?)?["message"] as String? ?? "",
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Change the password of the user.
  ///
  /// [newPassword] is the new password of the user.
  ///
  /// [currentPassword] is the current password of the user.
  ///
  /// [revokeOtherSessions] is the flag to remove other sessions of the user. Defaults to false.
  Future<ChangePasswordResponse> changePassword({
    required String newPassword,
    required String currentPassword,
    bool? revokeOtherSessions = false,
  }) async {
    try {
      final response = await _dio.post(
        "/change-password",
        data: {
          "newPassword": newPassword,
          "currentPassword": currentPassword,
          "revokeOtherSessions": revokeOtherSessions,
        },
        options: await _getOptions(),
      );
      return ChangePasswordResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Update the user's name and image.
  ///
  /// [name] is the new name of the user.
  ///
  /// [image] is the new image of the user.
  ///
  /// [username] is the new username of the user.
  Future<BaseResponseWithoutMessage> updateUser({String? name, String? image, String? username}) async {
    try {
      final response = await _dio.post(
        "/update-user",
        data: {"name": name, "image": image, "username": username},
        options: await _getOptions(),
      );
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Delete user
  ///
  /// [password] is the password of the user.
  ///
  /// [token] is the token sent using [sendDeleteAccountVerification]
  ///
  /// [callbackURL] is the URL to redirect to after the user is deleted.
  Future<BaseResponseWithoutMessage> deleteUser({String? password, String? token, String? callbackURL}) async {
    assert(password != null || token != null, "Either password or token must be provided");
    try {
      final response = await _dio.post(
        "/delete-user",
        data: {"password": password, "token": token, "callbackURL": callbackURL},
        options: password != null ? await _getOptions() : null,
      );
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// List all sessions of the user.
  Future<List<Session>> listSessions() async {
    try {
      final response = await _dio.get("/list-sessions", options: await _getOptions());
      return response.data.map((e) => Session.fromJson(e)).toList();
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Revoke a session
  ///
  /// [token] is the token of the session to revoke
  Future<BaseResponseWithoutMessage> revokeSession({required String token}) async {
    try {
      final response = await _dio.post("/revoke-session", data: {"token": token});
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Revoke all sessions of the user
  Future<BaseResponseWithoutMessage> revokeSessions() async {
    try {
      final response = await _dio.post("/revoke-sessions", options: await _getOptions());
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Revoke all sessions of the user except the current one
  Future<BaseResponseWithoutMessage> revokeOtherSessions() async {
    try {
      final response = await _dio.post("/revoke-other-sessions", options: await _getOptions());
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Link a social account to the user
  ///
  /// [provider] is the provider of the social account
  ///
  /// [callbackURL] is the URL to redirect to after the social account is linked
  ///
  /// [scopes] is the scopes to request from the social account
  Future<SocialSignInResponse> linkSocialAccount({
    required String provider,
    String? callbackURL,
    List<String>? scopes,
  }) async {
    try {
      final response = await _dio.post(
        "/link-social",
        data: {"provider": provider, "callbackURL": callbackURL, "scopes": scopes},
        options: await _getOptions(),
      );
      return SocialSignInResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// List all accounts of the user
  Future<List<Account>> listAccounts() async {
    try {
      final response = await _dio.get("/list-accounts", options: await _getOptions());
      return response.data.map((e) => Account.fromJson(e)).toList();
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Delete user
  ///
  /// [token] is the token of the account to delete
  ///
  /// [callbackURL] is the URL to redirect to after the account is deleted
  Future<BaseResponseWithoutMessage> deleteAccount({required String token, String? callbackURL}) async {
    try {
      final response = await _dio.post("/delete-user/callback?token=$token&callbackURL=$callbackURL");
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Unlink an account
  ///
  /// [providerId] is the id of the account to unlink
  ///
  /// [accountId] is the id of the account to unlink
  Future<BaseResponseWithoutMessage> unlinkAccount({required String providerId, String? accountId}) async {
    try {
      final response = await _dio.post(
        "/unlink-account",
        data: {"providerId": providerId, "accountId": accountId},
        options: await _getOptions(),
      );
      return BaseResponse.fromJson(response.data, (json) => null);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Refresh the access token using a refresh token
  ///
  /// [providerId] The provider ID for the OAuth provider
  ///
  /// [accountId] The account ID associated with the refresh token
  ///
  /// [userId] The user ID associated with the account
  Future<TokenRefresh> refreshToken({required String providerId, String? accountId, String? userId}) async {
    try {
      final response = await _dio.post(
        "/refresh-token",
        data: {"providerId": providerId, "accountId": accountId, "userId": userId},
      );
      return TokenRefresh.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
