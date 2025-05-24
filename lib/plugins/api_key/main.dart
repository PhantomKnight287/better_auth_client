import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/success_response.dart';
import 'package:better_auth_client/plugins/api_key/response/api_key.dart';
import 'package:better_auth_client/plugins/base.dart';

class ApiKeyPlugin extends BasePlugin {
  ApiKeyPlugin();

  /// Create an API Key
  ///
  /// [name] The name of the API Key
  /// [expiresIn] The expiration time of the API Key, in seconds
  /// [userId] The user ID of the user that the API Key belongs to. Useful for server-side only.
  /// [prefix] The prefix of the API Key
  /// [remaining] The remaining number of requests. Server side only
  /// [metadata] The metadata of the API Key
  /// [refillAmount] The amount to refill the remaining count of the API Key. Server Only Property
  /// [refillInterval] The interval to refill the remaining count of the API Key. Server Only Property.
  /// [rateLimitTimeWindow] The duration in milliseconds where each request is counted. Once the `maxRequests` is reached, the request will be rejected until the `timeWindow` has passed, at which point the `timeWindow` will be reset. Server Only Property.
  /// [rateLimitMax] The maximum amount of requests allowed within a window. Once the `maxRequests` is reached, the request will be rejected until the `timeWindow` has passed, at which point the `timeWindow` will be reset. Server Only Property
  /// [rateLimitEnabled] Whether the key has rate limiting enabled. Server Only Property.
  /// [permissions] The permissions of the API Key
  Future<ApiKey> create({
    String? name,

    int? expiresIn,

    String? userId,

    String? prefix,

    int? remaining,

    Map<String, dynamic>? metadata,

    int? refillAmount,

    int? refillInterval,

    int? rateLimitTimeWindow,

    int? rateLimitMax,

    bool? rateLimitEnabled,

    Map<String, List<String>>? permissions,
  }) async {
    try {
      final body = {};
      if (name != null) body['name'] = name;
      if (expiresIn != null) body['expiresIn'] = expiresIn;
      if (userId != null) body['userId'] = userId;
      if (prefix != null) body['prefix'] = prefix;
      if (remaining != null) body['remaining'] = remaining;
      if (metadata != null) body['metadata'] = metadata;
      if (refillAmount != null) body['refillAmount'] = refillAmount;
      if (refillInterval != null) body['refillInterval'] = refillInterval;
      if (rateLimitTimeWindow != null) body['rateLimitTimeWindow'] = rateLimitTimeWindow;
      if (rateLimitMax != null) body['rateLimitMax'] = rateLimitMax;
      if (rateLimitEnabled != null) body['rateLimitEnabled'] = rateLimitEnabled;
      if (permissions != null) body['permissions'] = permissions;

      final res = await super.dio.post(
        '/api-key/create',
        data: body,
        options: await super.getOptions(isTokenRequired: true),
      );
      return ApiKey.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get an API key with ID
  ///
  /// [id] The ID of the API key
  Future<ApiKey> get({required String id}) async {
    try {
      final res = await super.dio.get(
        '/api-key/get',
        options: await super.getOptions(isTokenRequired: true),
        queryParameters: {'id': id},
      );
      return ApiKey.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Update an API key
  Future<ApiKey> update({
    required String keyId,
    String? name,
    int? expiresIn,
    String? userId,
    int? remaining,
    Map<String, dynamic>? metadata,
    int? refillAmount,
    int? refillInterval,
    int? rateLimitTimeWindow,
    int? rateLimitMax,
    bool? rateLimitEnabled,
    Map<String, List<String>>? permissions,
  }) async {
    try {
      final Map<String, dynamic> body = {'keyId': keyId};
      if (name != null) body['name'] = name;
      if (expiresIn != null) body['expiresIn'] = expiresIn;
      if (userId != null) body['userId'] = userId;
      if (remaining != null) body['remaining'] = remaining;
      if (metadata != null) body['metadata'] = metadata;
      if (refillAmount != null) body['refillAmount'] = refillAmount;
      if (refillInterval != null) body['refillInterval'] = refillInterval;
      if (rateLimitTimeWindow != null) body['rateLimitTimeWindow'] = rateLimitTimeWindow;
      if (rateLimitMax != null) body['rateLimitMax'] = rateLimitMax;
      if (rateLimitEnabled != null) body['rateLimitEnabled'] = rateLimitEnabled;
      if (permissions != null) body['permissions'] = permissions;

      final res = await super.dio.post(
        '/api-key/update',
        data: body,
        options: await super.getOptions(isTokenRequired: true),
      );
      return ApiKey.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Delete an API key
  ///
  /// [keyId] The ID of the API key
  Future<SuccessResponse> delete({required String keyId}) async {
    try {
      final res = await super.dio.post(
        '/api-key/delete',
        data: {'keyId': keyId},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(res.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get all API keys
  Future<List<ApiKey>> list() async {
    try {
      final res = await super.dio.get('/api-key/list', options: await super.getOptions(isTokenRequired: true));
      return (res.data as List).map((e) => ApiKey.fromJson(e)).toList();
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
