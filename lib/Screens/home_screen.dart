import 'package:flutter/material.dart';
import 'sign_to_text_screen.dart';
import 'text_to_sign_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ISL Translator App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/isl_logo.png', height: 150),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.gesture),
              label: const Text("Sign to Text/Speech"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignToTextScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.record_voice_over),
              label: const Text("Text/Speech to Sign"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TextToSignScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
