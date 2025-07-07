import 'package:flutter/material.dart';
import 'package:get_calley/screen/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'lang': 'English', 'greeting': 'Hi'},
    {'lang': 'Hindi', 'greeting': 'नमस्ते'},
    {'lang': 'Bengali', 'greeting': 'হ্যালো'},
    {'lang': 'Kannada', 'greeting': 'ನಮಸ್ಕಾರ'},
    {'lang': 'Punjabi', 'greeting': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ'},
    {'lang': 'Tamil', 'greeting': 'வணக்கம்'},
    {'lang': 'Telugu', 'greeting': 'హలో'},
    {'lang': 'French', 'greeting': 'Bonjour'},
    {'lang': 'Spanish', 'greeting': 'Hola'},
  ];

  Future<void> _onSelect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', false);
    await prefs.setString('selected_language', selectedLanguage);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false, // 🔒 Prevent back button
    child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Choose Your Language",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 📋 Language List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      return RadioListTile(
                        title: Text(lang['lang']!),
                        subtitle: Text(lang['greeting']!),
                        value: lang['lang'],
                        groupValue: selectedLanguage,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value.toString();
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ✅ Select Button
              ElevatedButton(
                onPressed: _onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(37, 99, 235, 1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Select",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}
}