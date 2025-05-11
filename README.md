<h1 align="center">Better Auth Client</h1>
<p align="center">A pure dart client package for <a href="https://better-auth.com">Better Auth</a></p>

<div align="center">
Note: This repo will get most if not all of the updates on weekends or public holidays in India. I am unable to dedicate time to this out of my daily full time working schedule.
</div>



## Plugins Supported
- [x] Two Factor Authentication
- [x] Anonymous Authentication
- [x] Username

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

## Custom User Models

Better Auth Client allows you to customize the User model to include additional properties returned by your server. There are three approaches you can use:

### Approach 1: Dynamic Map

This approach automatically collects all non-standard properties into a `customProperties` map.

```dart
// Sign in to get a user with custom properties
final response = await client.signIn.email("test@example.com", "password");
final user = response.data;

// Access custom properties
final customValue = user?.customProperties["customField"];

final typedValue = user?.getCustomProperty<String>("customField");
```

### Approach 2: Extending the Base User Class

Use the `ExtendableUser` class for a cleaner inheritance approach:

```dart
class CustomUser extends ExtendableUser {
  final String customField;

  CustomUser({
    required super.id,
    required super.email,
    required super.name,
    super.image,
    required super.createdAt,
    required super.updatedAt,
    super.emailVerified,
    required this.customField,
    super.twoFactorEnabled,
    super.username,
    super.displayUsername,
    super.isAnonymous,
    super.phoneNumber,
    super.phoneNumberVerified,
    super.role,
    super.banned,
    super.banReason,
    super.banExpires,

  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      emailVerified: json['emailVerified'],
      twoFactorEnabled: json['twoFactorEnabled'],
      username: json['username'],
      displayUsername: json['displayUsername'],
      isAnonymous: json['isAnonymous'],
      phoneNumber: json['phoneNumber'],
      phoneNumberVerified: json['phoneNumberVerified'],
      role: json['role'],
      banned: json['banned'],
      banReason: json['banReason'],
      banExpires: json['banExpires'],
      customField: json['customField'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['customField'] = customField;
    return json;
  }
}

// Initialize client with custom user factory
final client = BetterAuthClient(
  baseUrl: "https://api.example.com",
  tokenStore: myTokenStore,
  fromJsonUser: CustomUser.fromJson,
);
```
