import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_page.dart';
import 'package:kora_quiz/sound_manager.dart';

class UserSettingsPage extends StatelessWidget {
  final String username;
  const UserSettingsPage({super.key, required this.username});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    SoundManager.playLogoutSound();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('logout_confirm_title'.tr()),
        content: Text('logout_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              SoundManager.playCancelSound();
              Navigator.pop(context);
            },
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr()),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${'welcome'.tr()} $username',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text('logout'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
