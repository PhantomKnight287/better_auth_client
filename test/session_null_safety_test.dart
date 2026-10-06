import 'dart:convert';
import 'dart:typed_data';

import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/models/response/session_response.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class InMemoryTokenStore extends TokenStore {
  String _token = '';

  @override
  Future<String> getToken() async => _token;

  @override
  Future<void> saveToken(String? token) async => _token = token ?? '';

  @override
  Future<String> getAdminToken() async => '';

  @override
  Future<void> saveAdminToken(String? token) async {}

  void setToken(String token) => _token = token;
}

final _validSessionJson = {
  'session': {
    'id': 'sess_1',
    'expiresAt': '2026-12-31T00:00:00.000Z',
    'token': 'tok_abc',
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
    'ipAddress': '127.0.0.1',
    'userAgent': 'test',
    'userId': 'user_1',
  },
  'user': {
    'id': 'user_1',
    'email': 'test@test.com',
    'name': 'Test',
    'createdAt': '2026-01-01T00:00:00.000Z',
    'updatedAt': '2026-01-01T00:00:00.000Z',
  },
};

void main() {
  // ──────────────────────────────────────────────
  // SessionResponse.fromJson unit tests
  // ──────────────────────────────────────────────
  group('SessionResponse.fromJson', () {
    test('parses valid JSON correctly', () {
      final result = SessionResponse<User>.fromJson(
        _validSessionJson,
        (json) => User.fromJson(json),
      );
      expect(result.session.id, equals('sess_1'));
      expect(result.user.id, equals('user_1'));
      expect(result.user.email, equals('test@test.com'));
    });

    test('throws FormatException when session field is null', () {
      expect(
        () => SessionResponse<User>.fromJson(
          {'session': null, 'user': _validSessionJson['user']},
          (json) => User.fromJson(json),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when user field is null', () {
      expect(
        () => SessionResponse<User>.fromJson(
          {'session': _validSessionJson['session'], 'user': null},
          (json) => User.fromJson(json),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when both fields are null', () {
      expect(
        () => SessionResponse<User>.fromJson(
          {'session': null, 'user': null},
          (json) => User.fromJson(json),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when session is a string instead of Map', () {
      expect(
        () => SessionResponse<User>.fromJson(
          {'session': 'invalid', 'user': _validSessionJson['user']},
          (json) => User.fromJson(json),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when fields are missing entirely', () {
      expect(
        () => SessionResponse<User>.fromJson(
          <String, dynamic>{},
          (json) => User.fromJson(json),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // ──────────────────────────────────────────────
  // hydrate() tests — no server needed, uses token check + null guard
  // ──────────────────────────────────────────────
  group('hydrate()', () {
    test('returns null when token is empty', () async {
      final store = InMemoryTokenStore();
      store.setToken('');
      final client = BetterAuthClient<User>(
        baseUrl: 'http://localhost:3000/api/auth',
        tokenStore: store,
      );
      final result = await client.hydrate();
      expect(result, isNull);
    });
  });
}
