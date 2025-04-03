import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'welcome_screen.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'change_password_page.dart'; 

class LoginPage extends StatefulWidget {
  final Locale? locale;

  const LoginPage({super.key, this.locale});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String serverUrl = 'https://koraquiz.com/api';

  Future<void> login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('login_fill_fields'.tr())),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomeScreen(),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${'login_failed'.tr()}: $error')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('connection_error'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'username_label'.tr()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password_label'.tr()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: login,
              child: Text('login_button'.tr()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterPage(locale: widget.locale ?? context.locale),
                  ),
                );
              },
              child: Text('no_account'.tr()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForgotPasswordPage(locale: widget.locale ?? context.locale),
                  ),
                );
              },
              child: Text('forgot_password'.tr()),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
              child: Text('change_password_button'.tr()), // ✅ استخدم الترجمة
            ),
          ],
        ),
      ),
    );
  }
}
