import 'package:better_auth_client/models/response/session.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_response.g.dart';

@JsonSerializable()
class SessionResponse {
  final Session session;
  final User user;

  SessionResponse({required this.session, required this.user});

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionResponseToJson(this);
}
