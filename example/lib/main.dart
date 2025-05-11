import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/models/token_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  StreamSubscription<Uri>? _linkSubscription;
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAppLinks();
  }

  Future<void> initAppLinks() async {
    // Handle app start with a link
    final appLinkUri = await appLinks.getInitialLink();
    if (appLinkUri != null) {
      handleAppLink(appLinkUri);
    }

    _linkSubscription = appLinks.uriLinkStream.listen(
      (Uri uri) {
        handleAppLink(uri);
      },
      onError: (err) {
        print('Error processing app link: $err');
      },
    );
  }

  void handleAppLink(Uri uri) {
    print(uri);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App has come back to the foreground
      if (!_isInForeground) {
        _isInForeground = true;
        print('App resumed from background, checking for deep links...');

        // Check for any pending deep links
        appLinks.getLatestLink().then((Uri? uri) {
          if (uri != null) {
            print('Found pending deep link on resume');
            handleAppLink(uri);
          }
        });
      }
    } else if (state == AppLifecycleState.paused) {
      // App has gone to the background
      _isInForeground = false;
      print('App paused (went to background)');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final res = await betterAuthClient.signIn.social(provider: "github", callbackURL: "/details", errorCallbackURL: "/error");
                final url = Uri.parse(res.url);
                final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: "bac", options: FlutterWebAuth2Options());
                final resultUrl = Uri.parse(result);
                await launchUrl(resultUrl, mode: LaunchMode.externalApplication);
              } catch (e) {
                print(e);
              }
            },
            child: Text("Sign in with github"),
          ),
        ),
      ),
    );
  }
}
