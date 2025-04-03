import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  Future<void> _setLanguage(BuildContext context, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', locale.languageCode); // ✅ حفظ اللغة
    if (!context.mounted) return;

    await context.setLocale(locale); // ✅ تغيير اللغة (بشكل آمن)

    // ✅ الانتقال إلى صفحة تسجيل الدخول مع تمرير اللغة
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(locale: locale)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر اللغة / Select Language'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _setLanguage(context, const Locale('ar')),
              icon: const Icon(Icons.language),
              label: const Text('العربية'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _setLanguage(context, const Locale('en')),
              icon: const Icon(Icons.language),
              label: const Text('English'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
