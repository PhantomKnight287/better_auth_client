import 'package:better_auth_client/better_auth_client.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SetAuthTokenHeaderInterceptor extends Interceptor {
  final TokenStore store;
  SetAuthTokenHeaderInterceptor({required this.store});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers.value("set-auth-token") != null) {
      store.saveToken(response.headers.value("set-auth-token"));
    }
    super.onResponse(response, handler);
  }
}

Dio generateDioClient(String baseUrl) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(
    PrettyDioLogger(
      request: true,
      requestBody: true,
      requestHeader: true,
      enabled: true,
      error: true,
      responseBody: true,
      responseHeader: true,
    ),
  );
  return dio;
}
