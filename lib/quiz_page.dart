import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'leaderboard_page.dart';
import 'welcome_screen.dart';
import 'package:kora_quiz/sound_manager.dart';

class QuizPage extends StatefulWidget {
  final String username;
  const QuizPage({super.key, required this.username});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late String username;
  Map<String, dynamic>? questionData;
  List<String> shuffledOptions = [];
  int correctAnswerIndex = -1;
  int points = 5;
  int currentQuestion = 0;
  final int totalQuestions = 20;
  List<int> usedQuestionIds = [];
  int timerSeconds = 13;
  Timer? countdownTimer;
  bool answered = false;

  List<String> headerImages = List.generate(48, (i) =>
      'https://koraquiz.com/assets/images/quiz_headers/${i + 1}.jpg')
    ..addAll([
      'https://koraquiz.com/assets/images/quiz_headers/1.webp',
      'https://koraquiz.com/assets/images/quiz_headers/2.webp',
      'https://koraquiz.com/assets/images/quiz_headers/3.webp',
    ]);

  List<String> usedHeaderImages = [];
  String? selectedHeaderImage;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchQuestion();
  }

  Future<void> fetchQuestion() async {
    countdownTimer?.cancel();
    timerSeconds = 13;

    final lang = context.locale.languageCode;
    final url = Uri.parse('https://koraquiz.com/api/question/random?lang=$lang');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (usedQuestionIds.contains(data['id'])) {
          fetchQuestion();
          return;
        }

        usedQuestionIds.add(data['id']);
        List<String> options = List<String>.from(data['options']);
        String correctOption = options[data['correct_answer'] - 1];
        options.shuffle();

        List<String> remainingImages =
            headerImages.where((img) => !usedHeaderImages.contains(img)).toList();
        if (remainingImages.isEmpty) {
          usedHeaderImages.clear();
          remainingImages = List.from(headerImages);
        }
        remainingImages.shuffle();
        String newImage = remainingImages.first;
        usedHeaderImages.add(newImage);

        setState(() {
          questionData = data;
          shuffledOptions = options;
          correctAnswerIndex = options.indexOf(correctOption);
          selectedHeaderImage = newImage;
          answered = false;
        });

        countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          setState(() {
            timerSeconds--;
          });
          if (timerSeconds <= 0) {
            timer.cancel();
            Future.delayed(const Duration(seconds: 1), () {
              checkAnswer(-1);
            });
          }
        });
      } else {
        throw Exception('فشل في جلب السؤال');
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('connection_error_title'.tr()),
          content: Text('connection_error'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                SoundManager.playClickSound();
                Navigator.of(context).pop();
                fetchQuestion();
              },
              child: Text('retry'.tr()),
            ),
            TextButton(
              onPressed: () {
                SoundManager.playClickSound();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                );
              },
              child: Text('back_to_home'.tr()),
            ),
          ],
        ),
      );
    }
  }

  Future<void> updatePointsToServer() async {
    if (username == 'guest') return;
    final url = Uri.parse('https://koraquiz.com/api/update_points');
    try {
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'points': points}),
      );
    } catch (e) {
      print("❌ فشل إرسال النقاط: $e");
    }
  }

  void checkAnswer(int selectedIndex) async {
    if (answered) return;
    answered = true;
    countdownTimer?.cancel();

    if (selectedIndex == correctAnswerIndex) {
      setState(() {
        points++;
      });
    } else {
      setState(() {
        points--;
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    if (points <= 0 || currentQuestion + 1 >= totalQuestions) {
      showResult();
    } else {
      setState(() {
        currentQuestion++;
      });
      fetchQuestion();
    }
  }

  void showResult() async {
    String resultKey;
    int maxPoints = 5 + totalQuestions;

    if (points >= 20) {
      resultKey = 'excellent';
    } else if (points >= 15) {
      resultKey = 'good';
    } else if (points >= 10) {
      resultKey = 'average';
    } else if (points >= 5) {
      resultKey = 'bad';
    } else {
      resultKey = 'fail';
    }

    await updatePointsToServer();

    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('result_title'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'score_label'.tr()}: $points / $maxPoints'),
              const SizedBox(height: 8),
              Text(resultKey.tr()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              child: Text('try_again'.tr()),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxPoints = 5 + totalQuestions;
    final scoreText = '${'score_label'.tr()}: $points / $maxPoints';
    final questionNumberText = '${'question_count'.tr()} ${currentQuestion < totalQuestions ? currentQuestion + 1 : totalQuestions} / $totalQuestions';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(scoreText),
        centerTitle: true,
        backgroundColor: Colors.blue[100],
      ),
      body: questionData == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://koraquiz.com/assets/images/quiz_bg.jpg',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.white.withOpacity(0.5)),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (selectedHeaderImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            selectedHeaderImage!,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          questionNumberText,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          '⏱️ $timerSeconds ${'seconds'.tr()}',
                          style: const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            questionData?['question'] ?? '',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...shuffledOptions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final text = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: answered ? null : () => checkAnswer(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(text, style: const TextStyle(fontSize: 18)),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
