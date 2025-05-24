import 'package:dio/dio.dart';

abstract class BasePlugin<T> {
  late final Dio dio;
  late final Future<Options> Function({bool isTokenRequired}) getOptions;
  late final Future<void> Function(String token) setToken;
  late final T Function(Map<String, dynamic> json) fromJsonUser;

  BasePlugin();

  void initialize({
    required Dio dio,
    required Future<Options> Function({bool isTokenRequired}) getOptions,
    required Future<void> Function(String token) setToken,
    required T Function(Map<String, dynamic> json) fromJsonUser,
  }) {
    this.dio = dio;
    this.getOptions = getOptions;
    this.setToken = setToken;
    this.fromJsonUser = fromJsonUser;
  }
}
