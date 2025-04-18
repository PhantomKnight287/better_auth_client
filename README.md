<h1 align="center">Better Auth Client</h1>
<p align="center">A pure dart client package for <a href="https://better-auth.com">Better Auth</a></p>

## Installation

```bash
dart pub add better_auth_client
```

## Setup

This package is pure dart and does not require any native code. However, it uses [dio](https://pub.dev/packages/dio) for networking so make sure internet permission is enabled in android and macos.

## Usage

Since this package is pure dart, it does not bother with any token storage method. You have to implement your own token storage by extending `TokenStore` class.

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
```

Now you can create a client and use it across the app.

```dart
final client = BetterAuthClient(baseUrl: "http://localhost:3000/api/auth", tokenStore: InMemoryTokenStore());
```

## Sign In

```dart
final response = await client.signIn.email("test@mail.com","Password","Test User");
```


The API of this package is similar to that of Better Auth's JS Client.