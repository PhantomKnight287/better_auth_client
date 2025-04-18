<h1 align="center">Better Auth Client</h1>
<p align="center">A pure dart client package for <a href="https://better-auth.com">Better Auth</a></p>

## Installation

```bash
dart pub add better_auth_client
```

## Setup

### Client Side

This package is pure dart and does not require any native code. However, it uses [dio](https://pub.dev/packages/dio) for networking so make sure internet permission is enabled in android and macos.

### Server Side

- This package requires [`bearer`](https://www.better-auth.com/docs/plugins/bearer) and [`expo`](https://www.better-auth.com/docs/integrations/expo) plugin to be enabled in your better auth server.
- Please setup universal links(for ios) and app links(for android) to make use of oauth sign in.

### Oauth Specific Setup

- Setup universal links(for ios) and app links(for android) using `app_links` or any other package you prefer.
- Add your url scheme in `trustedOrigins` array of better auth.

```ts
trustedOrigins: ["bac://fyi.procrastinator.better-auth-client", "bac://"],
```

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
final client = BetterAuthClient(baseUrl: "http://localhost:3000/api/auth", tokenStore: InMemoryTokenStore(), scheme: "bac://");
```

## Sign In

```dart
final response = await client.signIn.email("test@mail.com","Password","Test User");
```

The API of this package is similar to that of Better Auth's JS Client.

## Oauth

This package does not handle oauth redirects. You have to handle it yourself using [`flutter_web_auth_2`](https://pub.dev/packages/flutter_web_auth_2) or any other package you prefer.

