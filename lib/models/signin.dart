import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/request/id_token.dart';
import 'package:better_auth_client/models/response/social_sign_in_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/networking/response.dart';
import 'package:dio/dio.dart';

enum Provider { apple, google, github, discord, facebook, kick, tiktok, twitch, twitter, dropdox, linkedin, gitlab, reddit, roblox, spotify, vk, zoom }

extension ProviderId on Provider {
  String get id {
    return toString().split(".").elementAt(1);
  }
}

class Signin {
  final Dio _dio;
  final Function(String) _setToken;
  String? _scheme;
  Signin({required Dio dio, required Function(String) setToken, String? scheme}) : _dio = dio, _setToken = setToken, _scheme = scheme;

  Future<BetterAuthClientResponse<User, Exception>> email(String email, String password) async {
    try {
      final response = await _dio.post("/sign-in/email", data: {"email": email, "password": password});
      final body = response.data;
      _setToken(body["token"]);
      return BetterAuthClientResponse(data: User.fromJson(body["user"]), error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  Future<BetterAuthClientResponse<SocialSignInResponse, Exception>> signInWithAppleIdToken({required String token, String? nonce, String? accessToken}) async {
    try {
      final response = await _dio.post(
        "/sign-in/social",
        data: {
          "provider": "apple",
          "idToken": {"token": token, "nonce": nonce, "accessToken": accessToken},
        },
      );
      final body = response.data;
      _setToken(body["token"]);
      return BetterAuthClientResponse(data: SocialSignInResponse.fromJson(body), error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
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
  Future<BetterAuthClientResponse<SocialSignInResponse, Exception>> social({
    required Provider provider,
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
      final body = {"provider": provider.id};
      if (callbackURL != null) {
        body["callbackURL"] = "$_scheme$callbackURL";
      }
      final res = await _dio.post('/sign-in/social', data: body, options: Options(headers: {"expo-origin": _scheme}));
      return BetterAuthClientResponse(data: SocialSignInResponse.fromJson(res.data), error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  Future<BetterAuthClientResponse<dynamic, Exception>> socialWithIdToken({required String code, String? state, required Provider provider}) async {
    try {
      final queryParameters = {"code": code};
      if (state != null) {
        queryParameters["state"] = state;
      }
      final response = await _dio.post("/callback/${provider.id}", queryParameters: queryParameters);
      final body = response.data;
      // _setToken(body["token"]);
      return BetterAuthClientResponse(data: body, error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
