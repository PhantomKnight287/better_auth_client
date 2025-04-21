import 'package:better_auth_client/models/response/base_response.dart';
import 'package:better_auth_client/models/response/change_password_response.dart';
import 'package:better_auth_client/models/response/session.dart';
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

  factory StoredCookie.fromJson(Map<String, dynamic> json) => StoredCookie(value: json['value'], expires: json['expires'] != null ? DateTime.parse(json['expires']) : null);
}

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

  BetterAuthClient({required this.baseUrl, required this.tokenStore, this.scheme}) {
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
      await dio.post('/sign-out', options: Options(headers: {"Authorization": "Bearer ${await tokenStore.getToken()}"}));
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
      await dio.post("/reset-password", data: {"token": token, "newPassword": newPassword});
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
  Future<BetterAuthClientResponse<Session, Exception>> getSession() async {
    try {
      final response = await dio.get("/session", options: Options(headers: {"Authorization": "Bearer ${await tokenStore.getToken()}"}));
      return BetterAuthClientResponse(data: Session.fromJson(response.data), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  /// Verify the email of the user.
  ///
  /// [token] is the token that was sent to the user's email.
  ///
  /// [callbackURL] is the URL to redirect to after the email is verified.
  Future<BetterAuthClientResponse<VerifyEmailResponse, Exception>> verifyEmail({required String token, String? callbackURL}) async {
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
  Future<BetterAuthClientResponse<BaseResponseWithMessage, Exception>> changeEmail({required String newEmail, String? callbackURL}) async {
    try {
      final response = await dio.post("/change-email", data: {"newEmail": newEmail, "callbackURL": callbackURL});
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => (json as Map<String, dynamic>?)?["message"] as String? ?? ""), error: null);
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
  Future<BetterAuthClientResponse<ChangePasswordResponse, Exception>> changePassword({required String newPassword, required String currentPassword, bool? revokeOtherSessions = false}) async {
    try {
      final response = await dio.post("/change-password", data: {"newPassword": newPassword, "currentPassword": currentPassword, "revokeOtherSessions": revokeOtherSessions});
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
  Future<BetterAuthClientResponse<BaseResponseWithoutMessage, Exception>> updateUser({String? name, String? image}) async {
    try {
      final response = await dio.post("/update-user", data: {"name": name, "image": image});
      return BetterAuthClientResponse(data: BaseResponse.fromJson(response.data, (json) => null), error: null);
    } catch (e) {
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
