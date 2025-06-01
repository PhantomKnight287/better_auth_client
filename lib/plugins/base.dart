import 'package:better_auth_client/better_auth_client.dart';
import 'package:dio/dio.dart';

abstract class BasePlugin<T> {
  late final Dio dio;
  late final Future<Options> Function({bool isTokenRequired}) getOptions;
  late final TokenStore tokenStore;
  late final T Function(Map<String, dynamic> json) fromJsonUser;

  BasePlugin();

  void initialize({
    required Dio dio,
    required Future<Options> Function({bool isTokenRequired}) getOptions,
    required TokenStore tokenStore,
    required T Function(Map<String, dynamic> json) fromJsonUser,
  }) {
    this.dio = dio;
    this.getOptions = getOptions;
    this.tokenStore = tokenStore;
    this.fromJsonUser = fromJsonUser;
  }
}
