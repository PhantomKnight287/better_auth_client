import 'package:better_auth_client/models/response/base_response.dart';
import 'package:better_auth_client/models/response/change_password_response.dart';
import 'package:better_auth_client/models/response/session.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/models/response/verify_email.dart';
import 'package:better_auth_client/models/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:better_auth_client/models/signup.dart';
import 'package:better_auth_client/networking/main.dart';
import 'package:better_auth_client/networking/response.dart';
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
  /// example: http://10.0.2.2:3000/api/auth
  final String baseUrl;

  /// The token store to save and retrieve the token.
  ///
  /// You can implement your own token store by extending the [TokenStore] class.
  final TokenStore tokenStore;

  /// The Deep Link scheme of your app
  /// This will be used to open the callback urls
  String? scheme;
  late final Signup<T> signUp;
  late final Signin<T> signIn;
  late final Dio dio;

  /// Function to convert JSON to a custom user model
  /// If not provided, the default User.fromJson will be used
  final T Function(Map<String, dynamic>)? _fromJsonUser;

  BetterAuthClient({
    required this.baseUrl,
    required this.tokenStore,
    this.scheme,
    T Function(Map<String, dynamic>)? fromJsonUser,
  }) : _fromJsonUser = fromJsonUser ?? User.fromJson as T Function(Map<String, dynamic>) {
    _internal();
  }

  void _internal() {
    dio = generateDioClient(baseUrl);
    signUp = Signup<T>(dio: dio, setToken: tokenStore.saveToken, fromJsonUser: _fromJsonUser);
    signIn = Signin<T>(dio: dio, setToken: tokenStore.saveToken, scheme: scheme, fromJsonUser: _fromJsonUser);
  }

  Future<Options> _getOptions() async {
    return Options(headers: {"Authorization": "Bearer ${await tokenStore.getToken()}"});
  }

  /// Sign out the user. This calls [TokenStore.saveToken] with null.
  Future<BetterAuthClientResponse<void, Exception>> signOut() async {
    try {
      await dio.post('/sign-out', options: await _getOptions());
      await tokenStore.saveToken(null);
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Send a verification email to the user.
  Future<BetterAuthClientResponse<void, Exception>> sendVerificationEmail(String email, {String? callbackURL}) async {
    try {
      await dio.post("/send-verification-email", data: {"email": email, "callbackURL": callbackURL});
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Send a forgot password email to the user.
  Future<BetterAuthClientResponse<void, Exception>> forgetPassword(String email, {String? callbackURL}) async {
    try {
      await dio.post("/forget-password", data: {"email": email, "callbackURL": callbackURL});
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Reset the password of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  Future<BetterAuthClientResponse<void, Exception>> resetPassword(String token, String newPassword) async {
    try {
      await dio.post(
        "/reset-password",
        data: {"token": token, "newPassword": newPassword},
        options: await _getOptions(),
      );
      return BetterAuthClientResponse(data: null, error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
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
  Future<BetterAuthClientResponse<SessionResponse<T>, Exception>> getSession() async {
    try {
      final response = await dio.get("/get-session", options: await _getOptions());
      return BetterAuthClientResponse(
        data: SessionResponse.fromJson(
          response.data,
          _fromJsonUser ?? User.fromJson as T Function(Map<String, dynamic>),
        ),
        error: null,
      );
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Verify the email of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  ///
  /// [callbackURL] is the URL to redirect to after the email is verified.
  Future<BetterAuthClientResponse<VerifyEmailResponse, Exception>> verifyEmail({
    required String token,
    String? callbackURL,
  }) async {
    try {
      final response = await dio.post("/verify-email", queryParameters: {"token": token, "callbackURL": callbackURL});
      return BetterAuthClientResponse(data: VerifyEmailResponse.fromJson(response.data), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Change the email of the user.
  ///
  /// [newEmail] is the new email of the user.
  ///
  /// [callbackURL] is the URL to redirect to after the email is changed.
  Future<BetterAuthClientResponse<BaseResponseWithMessage, Exception>> changeEmail({
    required String newEmail,
    String? callbackURL,
  }) async {
    try {
      final response = await dio.post(
        "/change-email",
        data: {"newEmail": newEmail, "callbackURL": callbackURL},
        options: await _getOptions(),
      );
      return BetterAuthClientResponse(
        data: BaseResponse.fromJson(
          response.data,
          (json) => (json as Map<String, dynamic>?)?["message"] as String? ?? "",
        ),
        error: null,
      );
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Change the password of the user.
  ///
  /// [newPassword] is the new password of the user.
  ///
  /// [currentPassword] is the current password of the user.
  ///
  /// [revokeOtherSessions] is the flag to remove other sessions of the user. Defaults to false.
  Future<BetterAuthClientResponse<ChangePasswordResponse, Exception>> changePassword({
    required String newPassword,
    required String currentPassword,
    bool? revokeOtherSessions = false,
  }) async {
    try {
      final response = await dio.post(
        "/change-password",
        data: {
          "newPassword": newPassword,
          "currentPassword": currentPassword,
          "revokeOtherSessions": revokeOtherSessions,
        },
        options: await _getOptions(),
      );
      return BetterAuthClientResponse(data: ChangePasswordResponse.fromJson(response.data), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Update the user's name and image.
  ///
  /// [name] is the new name of the user.
  ///
  /// [image] is the new image of the user.
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> updateUser({
    String? name,
    String? image,
  }) async {
    try {
      final response = await dio.post(
        "/update-user",
        data: {"name": name, "image": image},
        options: await _getOptions(),
      );
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Delete user
  ///
  /// [password] is the password of the user.
  ///
  /// [token] is the token sent using [sendDeleteAccountVerification]
  ///
  /// [callbackURL] is the URL to redirect to after the user is deleted.
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> deleteUser({
    String? password,
    String? token,
    String? callbackURL,
  }) async {
    try {
      assert(password != null || token != null, "Either password or token must be provided");
      final response = await dio.post(
        "/delete-user",
        data: {"password": password, "token": token, "callbackURL": callbackURL},
        options: password != null ? await _getOptions() : null,
      );
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// List all sessions of the user.
  Future<BetterAuthClientResponse<List<Session>, Exception>> listSessions() async {
    try {
      final response = await dio.get("/list-sessions", options: await _getOptions());
      return BetterAuthClientResponse(data: response.data.map((e) => Session.fromJson(e)).toList(), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Revoke a session
  ///
  /// [token] is the token of the session to revoke
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> revokeSession({required String token}) async {
    try {
      final response = await dio.post("/revoke-session", data: {"token": token});
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Revoke all sessions of the user
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> revokeSessions() async {
    try {
      final response = await dio.post("/revoke-sessions", options: await _getOptions());
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Revoke all sessions of the user except the current one
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> revokeOtherSessions() async {
    try {
      final response = await dio.post("/revoke-other-sessions", options: await _getOptions());
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
