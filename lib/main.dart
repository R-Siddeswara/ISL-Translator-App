import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ISLTranslatorApp());
}

class ISLTranslatorApp extends StatelessWidget {
  const ISLTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISL Translator',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
