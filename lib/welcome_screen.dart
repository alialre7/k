import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'quiz_intro.dart';
import 'package:kora_quiz/sound_manager.dart';

class WelcomeScreen extends StatefulWidget {
  final Locale? locale;

  const WelcomeScreen({super.key, this.locale});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.locale != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.setLocale(widget.locale!);
        }
      });
    }
  }

  void _startQuiz() {
    SoundManager.playClickSound();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const QuizIntroPage()),
    );
  }

  void _goToLogin() {
    SoundManager.playClickSound();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _goToLogin,
            child: Text(
              'login'.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/language_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_soccer, size: 100, color: Colors.blue),
                  const SizedBox(height: 24),
                  Text(
                    'welcome_title'.tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'welcome_subtitle'.tr(),
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'start'.tr(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🌍 ', style: TextStyle(fontSize: 18, color: Colors.white)),
                      TextButton(
                        onPressed: () => context.setLocale(const Locale('ar')),
                        child: const Text('العربية', style: TextStyle(color: Colors.white)),
                      ),
                      const Text('|', style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () => context.setLocale(const Locale('en')),
                        child: const Text('English', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
