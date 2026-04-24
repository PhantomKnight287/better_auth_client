import 'package:better_auth_client/better_auth_client.dart';
import 'package:test/test.dart';

class InMemoryTokenStore extends TokenStore {
  String? _token;
  String? _adminToken;

  @override
  Future<String> getToken() {
    return Future.value(_token ?? "");
  }

  @override
  Future<void> saveToken(String? token) {
    _token = token;
    return Future.value();
  }

  @override
  Future<String> getAdminToken() {
    return Future.value(_adminToken ?? "");
  }

  @override
  Future<void> saveAdminToken(String? token) {
    _adminToken = token;
    return Future.value();
  }
}

void main() {
  late InMemoryTokenStore mockTokenStore;
  late BetterAuthClient<User> client;
  const baseUrl = 'http://localhost:3000/api/auth';

  setUp(() {
    mockTokenStore = InMemoryTokenStore();
    client = BetterAuthClient<User>(baseUrl: baseUrl, tokenStore: mockTokenStore);
  });

  group('BetterAuthClient Initialization', () {
    test('should initialize with required parameters', () {
      expect(client.baseUrl, equals(baseUrl));
      expect(client.tokenStore, equals(mockTokenStore));
    });

    test('should initialize plugins', () {
      expect(client.signUp, isNotNull);
      expect(client.signIn, isNotNull);
      expect(client.twoFactor, isNotNull);
      expect(client.phoneNumber, isNotNull);
      expect(client.magicLink, isNotNull);
      expect(client.emailOtp, isNotNull);
      expect(client.oneTimeToken, isNotNull);
    });
  });

  group("Sign In", () {
    test("should sign in with email", () async {
      final response = await client.signIn.email(email: "test@mail.com", password: "password");
      expect(response.email, equals("test@mail.com"));
    });
  });
}
