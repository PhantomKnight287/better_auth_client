import 'package:json_annotation/json_annotation.dart';

part 'status_response.g.dart';

@JsonSerializable()
class StatusResponse {
  final bool status;

  StatusResponse({required this.status});

  factory StatusResponse.fromJson(Map<String, dynamic> json) => _$StatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusResponseToJson(this);
}
