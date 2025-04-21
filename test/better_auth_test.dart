import 'package:better_auth_client/models/client.dart';
import 'package:better_auth_client/models/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:test/test.dart';
import 'dart:io';

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
  final client = BetterAuthClient(baseUrl: "http://localhost:3000/api/auth", tokenStore: InMemoryTokenStore());

  final response = await client.signIn.social(provider: Provider.github);

  if (response.error != null) {
    throw response.error!;
  } else {
    final url = response.data?.url;
    if (url != null) {
      print('Opening browser for authentication...');
      try {
        await openUrl(url);

        // Wait for user to complete authentication
        print('Please complete the authentication in your browser...');
        print('Press Enter when done...');
        await stdin.readLineSync();

        // After authentication, print the response
        print('Authentication response:');
        print(response.data);
      } catch (e) {
        print('Error opening URL: $e');
      }
    } else {
      print('No authentication URL found in response');
    }
  }
}
