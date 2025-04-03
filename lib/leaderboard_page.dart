import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String? username;
  int? userPoints;
  List<dynamic> topPlayers = [];
  bool isLoading = true;

  final String serverUrl = 'https://koraquiz.com/api';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');

    if (mounted) {
      setState(() {
        username = savedUsername;
      });
      if (username != null) {
        fetchData();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchData() async {
    try {
      final pointsResponse = await http.post(
        Uri.parse('$serverUrl/get_points'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      final topResponse = await http.get(Uri.parse('$serverUrl/top_players'));

      if (pointsResponse.statusCode == 200 && topResponse.statusCode == 200) {
        setState(() {
          userPoints = json.decode(pointsResponse.body)['total_points'];
          topPlayers = json.decode(topResponse.body);
          isLoading = false;
        });
      } else {
        throw Exception("فشل في تحميل البيانات");
      }
    } catch (e) {
      print("⚠️ خطأ: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("leaderboard_title".tr()),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : username == null
              ? Center(child: Text("login_fill_fields".tr()))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.deepPurple[100],
                      child: Column(
                        children: [
                          Text(
                            '${'welcome'.tr()} $username',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${'score_label'.tr()}: $userPoints',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'top_players_label'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: topPlayers.length,
                        itemBuilder: (context, index) {
                          final player = topPlayers[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text('${player['rank']}'),
                            ),
                            title: Text(player['username']),
                            trailing: Text('${player['total_points']} ${'points'.tr()}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
