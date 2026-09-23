import 'package:flutter/material.dart';

class TextToSignScreen extends StatefulWidget {
  const TextToSignScreen({super.key});

  @override
  State<TextToSignScreen> createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final TextEditingController _controller = TextEditingController();
  String _input = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text to ISL Sign")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _input = val;
                });
              },
            ),
            const SizedBox(height: 24),
            if (_input.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _input
                    .toUpperCase()
                    .replaceAll(RegExp(r'[^A-Z]'), '')
                    .split('')
                    .map(
                      (char) => Image.asset(
                        'assets/ISL_Dataset/$char.png',
                        width: 64,
                        height: 64,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              char,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
