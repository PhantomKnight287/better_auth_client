import 'package:better_auth_client/models/client.dart';
import 'package:better_auth_client/models/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:test/test.dart';

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
  final client = BetterAuthClient(baseUrl: "http://localhost:3000/api/auth", tokenStore: InMemoryTokenStore());
  final response = await client.signIn.social(provider: Provider.github);
  if (response.error != null) {
    throw response.error!;
  } else {
    print(response.data);
  }
}
