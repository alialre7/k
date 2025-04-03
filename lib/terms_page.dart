import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('terms_title'.tr()),
        backgroundColor: Colors.green,
        centerTitle: true, // ✅ لتوسيط العنوان
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'terms_intro'.tr(),
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 24),
                Text(
                  'terms_privacy_title'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  'terms_privacy_content'.tr(),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'terms_ads_title'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  'terms_ads_content'.tr(),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'terms_consent'.tr(),
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
