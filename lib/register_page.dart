import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'login_page.dart';
import 'terms_page.dart';

class RegisterPage extends StatefulWidget {
  final Locale? locale;

  const RegisterPage({super.key, this.locale});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // ✅ استخدم رابط النطاق الرسمي بدلاً من IP
  final String serverUrl = 'https://koraquiz.com/api';
  bool acceptedTerms = false;

  Future<void> register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('register_required_fields'.tr())),
      );
      return;
    }

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_accept_terms'.tr())),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'lang': context.locale.languageCode,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('register_success'.tr())),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage(locale: widget.locale ?? context.locale)),
        );
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('register_fail'.tr(namedArgs: {'error': error}))),
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
    if (widget.locale != null) {
      context.setLocale(widget.locale!);
    }

    return Scaffold(
      appBar: AppBar(title: Text('register_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'username'.tr()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'.tr()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email_optional'.tr(),
                helperText: 'email_optional_hint'.tr(),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Checkbox للموافقة على الشروط
            Row(
              children: [
                Checkbox(
                  value: acceptedTerms,
                  onChanged: (value) {
                    setState(() {
                      acceptedTerms = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TermsPage()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'accept_terms'.tr(),
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: register,
              child: Text('create_account'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}