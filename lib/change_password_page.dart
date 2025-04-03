import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final String serverUrl = 'https://koraquiz.com/api';

  Future<void> changePassword() async {
    final username = _usernameController.text.trim();
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (username.isEmpty || oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى ملء جميع الحقول")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/change_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'تم التحديث')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'حدث خطأ')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ خطأ في الاتصال بالسيرفر")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تغيير كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة المرور المؤقتة'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: changePassword,
              child: const Text("تغيير كلمة المرور"),
            ),
          ],
        ),
      ),
    );
  }
}
