import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/networking/response.dart';
import 'package:dio/dio.dart';

class Signup {
  final Dio _dio;
  final Function(String) _setToken;
  Signup({required Dio dio, required Function(String) setToken})
    : _dio = dio,
      _setToken = setToken;

  Future<BetterAuthClientResponse<User, Exception>> email(
    String email,
    String password,
    String name, {
    String? image,
  }) async {
    try {
      final response = await _dio.post(
        "/sign-up/email",
        data: {
          "email": email,
          "password": password,
          "name": name,
          "image": image,
        },
      );
      final body = response.data;
      _setToken(body["token"]);
      return BetterAuthClientResponse(
        data: User.fromJson(body["user"]),
        error: null,
      );
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(
          data: null,
          error: Exception(dioErrorToMessage(e)),
        );
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
