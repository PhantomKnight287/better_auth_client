import 'package:json_annotation/json_annotation.dart';

part 'api_key.g.dart';

@JsonSerializable()
class ApiKey {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? prefix;
  String? start;
  String? key;
  bool? enabled;
  String? expiresAt;
  String? userId;
  String? lastRefillAt;
  String? lastRequest;
  Map<String, dynamic>? metadata;
  int? rateLimitMax;
  int? rateLimitTimeWindow;
  int? remaining;
  int? refillAmount;
  int? refillInterval;
  bool? rateLimitEnabled;
  int? requestCount;
  Map<String, List<String>>? permissions;

  ApiKey({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.prefix,
    this.start,
    this.key,
    this.enabled,
    this.expiresAt,
    this.userId,
    this.lastRefillAt,
    this.lastRequest,
    this.metadata,
    this.rateLimitMax,
    this.rateLimitTimeWindow,
    this.remaining,
    this.refillAmount,
    this.refillInterval,
    this.rateLimitEnabled,
    this.requestCount,
    this.permissions,
  });

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);
}
