import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:better_auth_client/networking/response.dart';
import 'package:dio/dio.dart';

class Signup<T extends User> {
  final Dio _dio;
  final Function(String) _setToken;
  final T Function(Map<String, dynamic>)? _fromJsonUser;

  Signup({required Dio dio, required Function(String) setToken, T Function(Map<String, dynamic>)? fromJsonUser})
    : _dio = dio,
      _setToken = setToken,
      _fromJsonUser = fromJsonUser;

  Future<BetterAuthClientResponse<T, Exception>> email({
    required String name,
    required String email,
    required String password,
    String? image,
  }) async {
    try {
      final response = await _dio.post(
        "/sign-up/email",
        data: {"email": email, "password": password, "name": name, "image": image},
      );
      final body = response.data;
      _setToken(body["token"]);

      // Use custom fromJson if provided, otherwise use default User.fromJson
      final user =
          _fromJsonUser != null
              ? _fromJsonUser!(body["user"])
              : throw Exception("Custom fromJsonUser function is required when using a custom User type");

      return BetterAuthClientResponse(data: user, error: null);
    } catch (e) {
      if (e is DioException) {
        return BetterAuthClientResponse(data: null, error: Exception(dioErrorToMessage(e)));
      }
      return BetterAuthClientResponse(data: null, error: e as Exception);
    }
  }
}
