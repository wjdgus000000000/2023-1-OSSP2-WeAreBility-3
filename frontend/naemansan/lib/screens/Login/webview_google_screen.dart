import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewGoogle extends StatefulWidget {
  final String loginUrl;

  const WebViewGoogle({Key? key, required this.loginUrl}) : super(key: key);

  @override
  State<WebViewGoogle> createState() => _WebViewGoogleState();
}

class _WebViewGoogleState extends State<WebViewGoogle> {
  @override
  void initState() {
    super.initState();
  }

  successLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/index', (route) => false);
  }

  failedLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: const Text('Failed to log in. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Login'),
        elevation: 2,
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
      body: WebView(
        initialUrl: widget.loginUrl,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        userAgent: "random",
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith(
              'https://ossp.dcs-hyungjoon.com/auth/google/callback')) {
            // Callback URL reached, process the token
            String code = Uri.parse(request.url).queryParameters['code'] ?? '';
            print("2️⃣ CODE는 : $code");

            // Token request
            var response = await http.get(
              Uri.parse(
                  "https://ossp.dcs-hyungjoon.com/auth/google/callback?code=$code"),
            );

            var parsedResponse = jsonDecode(response.body);
            print("2️⃣CODE를 보낸 후 내가 받은 토큰은 : $parsedResponse");

            if (response.statusCode == 200) {
              // API response value
              String accessToken =
                  parsedResponse['data']['jwt']['access_token'];
              String refreshToken =
                  parsedResponse['data']['jwt']['refresh_token'];
              await saveTokens(accessToken, refreshToken);

              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLogged', true);
              successLogin();
            } else {
              failedLogin();
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'accessToken', value: accessToken);
  await storage.write(key: 'refreshToken', value: refreshToken);
}