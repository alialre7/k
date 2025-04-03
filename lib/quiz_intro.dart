import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'quiz_page.dart';
import 'leaderboard_page.dart';
import 'login_page.dart';
import 'welcome_screen.dart';
import 'package:kora_quiz/sound_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizIntroPage extends StatefulWidget {
  const QuizIntroPage({super.key});

  @override
  State<QuizIntroPage> createState() => _QuizIntroPageState();
}

class _QuizIntroPageState extends State<QuizIntroPage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  void _showLogoutConfirmation(BuildContext context) {
    SoundManager.playClickSound();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('logout_confirm_title'.tr()),
        content: Text('logout_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              SoundManager.playCancelSound();
              Navigator.of(ctx).pop();
            },
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              SoundManager.playLogoutSound();
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              final currentLocale = context.locale;
              Navigator.of(ctx).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage(locale: currentLocale)),
                (route) => false,
              );
            },
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    SoundManager.playClickSound();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('intro_title'.tr()),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'back_to_home'.tr(),
          onPressed: () {
            SoundManager.playClickSound();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ استبدل الخلفية لتكون من الإنترنت (للتوافق مع GitHub Pages)
          Image.network(
            'https://koraquiz.com/assets/images/intro_bg.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'intro_message'.tr(),
                    style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.8),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      SoundManager.playClickSound();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => QuizPage(username: username ?? "guest"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'start'.tr(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: Icon(username == null ? Icons.login : Icons.logout),
                      onPressed: username == null
                          ? _goToLogin
                          : () => _showLogoutConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: username == null ? Colors.blueAccent : Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: Text(
                        username == null ? 'login'.tr() : 'logout'.tr(),
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.emoji_events, color: Colors.white),
                      onPressed: () {
                        SoundManager.playClickSound();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B61FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        shadowColor: Colors.purpleAccent,
                        elevation: 6,
                      ),
                      label: Text(
                        'leaderboard_title'.tr(),
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
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