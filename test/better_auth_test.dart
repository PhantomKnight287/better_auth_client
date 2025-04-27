import 'package:better_auth_client/models/client.dart';
import 'package:better_auth_client/models/response/extendable_user.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'dart:io';

class PremiumUser extends ExtendableUser {
  final bool premium;

  PremiumUser({
    required super.id,
    required super.email,
    required super.name,
    super.image,
    required super.createdAt,
    required super.updatedAt,
    super.isEmailVerified,
    required this.premium,
  });

  factory PremiumUser.fromJson(Map<String, dynamic> json) => PremiumUser(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    image: json['image'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    isEmailVerified: json['isEmailVerified'],
    premium: json['premium'],
  );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['premium'] = premium;
    return json;
  }
}

class InMemoryTokenStore extends TokenStore {
  String? _token;

  @override
  Future<String> getToken() {
    print("Getting token: $_token");
    return Future.value(_token ?? "");
  }

  @override
  Future<void> saveToken(String? token) {
    _token = token;
    return Future.value();
  }
}

Future<void> openUrl(String url) async {
  if (Platform.isWindows) {
    await Process.run('start', [url], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', [url], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', [url], runInShell: true);
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}

void main() async {
  final client = BetterAuthClient<PremiumUser>(
    baseUrl: "http://localhost:3000/api/auth",
    tokenStore: InMemoryTokenStore(),
    fromJsonUser: PremiumUser.fromJson,
  );

  final response = await client.signIn.email(email: 'test@mail.com', password: 'password');

  if (response.error != null) {
    throw response.error!;
  } else {
    print(response.data);
  }
  final session = await client.getSession();
  print(session.error);
}
