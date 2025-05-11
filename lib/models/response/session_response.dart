import 'package:better_auth_client/models/response/session.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class SessionResponse<T extends User> {
  final Session session;
  final T user;

  SessionResponse({required this.session, required this.user});

  factory SessionResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return SessionResponse(session: Session.fromJson(json['session']), user: fromJsonT(json['user']));
  }

  Map<String, dynamic> toJson() {
    return {'session': session.toJson(), 'user': user.toJson()};
  }
}
