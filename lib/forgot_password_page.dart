import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Locale? locale;

  const ForgotPasswordPage({super.key, this.locale});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final String serverUrl = 'https://koraquiz.com/api';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.locale != null) {
      context.setLocale(widget.locale!);
    }
  }

  Future<void> sendResetRequest() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('enter_email'.tr())),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/forgot_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('reset_email_sent'.tr())),
        );
      } else {
        final error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'reset_email_error'.tr()}: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('connection_error'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('forgot_password_title'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'email_label'.tr()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: sendResetRequest,
              child: Text('send_reset_button'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
