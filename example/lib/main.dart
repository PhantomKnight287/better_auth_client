import 'package:app_links/app_links.dart';
import 'package:better_auth_client/models/client.dart';
import 'package:better_auth_client/models/signin.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SharedPreferencesTokenStore extends TokenStore {
  @override
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? "";
  }

  @override
  Future<void> saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token ?? "");
  }
}

late BetterAuthClient betterAuthClient;
final appLinks = AppLinks();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  betterAuthClient = BetterAuthClient(tokenStore: SharedPreferencesTokenStore(), baseUrl: "http://localhost:3000/api/auth", scheme: "bac://");
  appLinks.uriLinkStream.listen((uri) {
    print(uri);
  });
  appLinks.stringLinkStream.listen((link) {
    print(link);
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final res = await betterAuthClient.signIn.social(provider: Provider.github, callbackURL: "details");
              print(res.error);
              if (res.data == null) return;
              final url = Uri.parse(res.data!.url);

              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
                webViewConfiguration: WebViewConfiguration(enableJavaScript: true),
                browserConfiguration: BrowserConfiguration(showTitle: true),
              );
            },
            child: Text("Sign in with github"),
          ),
        ),
      ),
    );
  }
}
