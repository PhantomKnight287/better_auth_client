import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

typedef BaseResponseWithMessage = BaseResponse<String>;
typedef BaseResponseWithoutMessage = BaseResponse<void>;

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  final bool status;
  @JsonKey(includeIfNull: false)
  final T? message;

  BaseResponse({required this.status, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$BaseResponseToJson(this, toJsonT);
}
