A client package for [Better Auth](https://better-auth.com).

## Usage

```dart

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

final client = BetterAuthClient(baseUrl: "http://localhost:3000/api/auth", tokenStore: InMemoryTokenStore());
final response = await client.signIn.email("test@mail.com","Password","Test User");
```
