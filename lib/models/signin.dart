import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/networking/response.dart';
import 'package:dio/dio.dart';

enum Provider { apple, google, github, discord, facebook, kick, tiktok, twitch, twitter, dropdox, linkedin, gitlab, reddit, roblox, spotify, vk, zoom }

class Signin {
  final Dio _dio;
  final Function(String) _setToken;
  Signin({required Dio dio, required Function(String) setToken}) : _dio = dio, _setToken = setToken;

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

  Future<BetterAuthClientResponse<SessionResponse, Exception>> signInWithAppleIdToken({required String token, String? nonce, String? accessToken}) async {
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
      return BetterAuthClientResponse(data: SessionResponse.fromJson(body), error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }

  Future<BetterAuthClientResponse<dynamic, Exception>> social({required Provider provider}) async {
    try {
      final res = await _dio.post('/sign-in/social', data: {"provider": provider.toString().split(".").elementAt(1)});
      return BetterAuthClientResponse(data: SessionResponse.fromJson(res.data), error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
