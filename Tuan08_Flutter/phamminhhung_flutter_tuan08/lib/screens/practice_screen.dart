// file: lib/screens/practice_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocabulary.dart';
import '../notification_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final TextEditingController answerController = TextEditingController();
  final NotificationService _notiService = NotificationService();
  
  int correctCount = 0;
  int wrongCount = 0;
  Vocabulary? currentVocab;

  @override
  void initState() {
    super.initState();
    nextWord();
  }

  void nextWord() {
    if (globalVocabs.isEmpty) return;
    setState(() {
      currentVocab = globalVocabs[Random().nextInt(globalVocabs.length)];
      answerController.clear();
    });
  }

  void checkAnswer() {
    if (currentVocab == null) return;
    
    bool isCorrect = answerController.text.trim().toLowerCase() == currentVocab!.meaning.toLowerCase();
    
    if (isCorrect) {
      correctCount++;
      showResultSnackbar('Chính xác!', Colors.green);
      nextWord();
    } else {
      wrongCount++;
      showResultSnackbar('Sai rồi!', Colors.red);
      
      // Bội số của 3 thì hiện notification nhắc nhở
      if (wrongCount % 3 == 0) {
        _notiService.showSimpleNotification(
          id: 999,
          title: 'Cảnh báo học tập!',
          body: 'Bạn đã trả lời sai $wrongCount lần. Hãy tập trung hơn nhé!',
        );
      }
      setState(() {});
    }
  }

  void showResultSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập từ mới', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Cụm đếm số câu Đúng/Sai
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(label: Text('✔️ $correctCount từ'), backgroundColor: Colors.greenAccent),
                const SizedBox(width: 20),
                Chip(label: Text('❌ $wrongCount từ'), backgroundColor: Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 30),
            
            // Khung hiển thị từ vựng
            if (globalVocabs.isEmpty)
              const Text('Chưa có từ vựng nào để học!')
            else
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      currentVocab!.word,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: answerController,
                      decoration: InputDecoration(
                        hintText: 'Nhập nghĩa tiếng Việt',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: checkAnswer,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Check', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}