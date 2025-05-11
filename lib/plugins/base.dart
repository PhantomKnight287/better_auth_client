import 'package:dio/dio.dart';

abstract class BasePlugin<T> {
  final Dio dio;
  final Future<Options> Function() getOptions;
  final Future<void> Function(String token) setToken;
  final T Function(Map<String, dynamic> json) fromJsonUser;

  BasePlugin({required this.dio, required this.getOptions, required this.setToken, required this.fromJsonUser});
}
