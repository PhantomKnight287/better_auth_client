import 'package:dio/dio.dart';

Dio generateDioClient(String baseUrl) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  return dio;
}
