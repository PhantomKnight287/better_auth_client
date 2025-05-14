import 'package:better_auth_client/better_auth_client.dart';

class PremiumUser extends ExtendableUser {
  final bool premium;

  PremiumUser({
    required super.id,
    required super.email,
    required super.name,
    super.image,
    required super.createdAt,
    required super.updatedAt,
    super.emailVerified,
    required this.premium,
  });

  factory PremiumUser.fromJson(Map<String, dynamic> json) => PremiumUser(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    image: json['image'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    emailVerified: json['emailVerified'],
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
    return Future.value(_token ?? "");
  }

  @override
  Future<void> saveToken(String? token) {
    _token = token;
    return Future.value();
  }
}

void main() async {
  final client = BetterAuthClient<PremiumUser>(
    baseUrl: "http://localhost:3000/api/auth",
    tokenStore: InMemoryTokenStore(),
    fromJsonUser: PremiumUser.fromJson,
  );

  try {
    final response = await client.signIn.email(
      email: 'test@mail.com',
      password: 'password',
    );
    print(response);
  } catch (e, stack) {
    print(e);
    print(stack);
  }
  try {
    // final session = await client.getSession();
    // print(session);
  } catch (e, stack) {
    print(e);
    print(stack);
  }
  await client.phoneNumber.sendOTP(phoneNumber: "+1234567890");
}
