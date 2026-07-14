import 'package:better_auth_client/models/response/session.dart';
import 'package:better_auth_client/models/response/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class SessionResponse<T extends User> {
  final Session session;
  final T user;

  SessionResponse({required this.session, required this.user});

  factory SessionResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final sessionJson = json['session'];
    final userJson = json['user'];
    if (sessionJson is! Map<String, dynamic> || userJson is! Map<String, dynamic>) {
      throw FormatException('Invalid session response: missing "session" or "user" field');
    }
    return SessionResponse(session: Session.fromJson(sessionJson), user: fromJsonT(userJson));
  }

  Map<String, dynamic> toJson() {
    return {'session': session.toJson(), 'user': user.toJson()};
  }
}
