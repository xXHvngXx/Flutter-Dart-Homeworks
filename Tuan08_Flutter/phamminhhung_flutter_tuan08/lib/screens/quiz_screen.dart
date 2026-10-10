import 'package:flutter/material.dart';
import 'dart:math';
import '../models/vocabulary.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int correctCount = 0;
  int wrongCount = 0;
  int currentIndex = 0;
  List<Vocabulary> quizList = [];
  String displayedMeaning = '';
  bool isMeaningCorrect = true;

  @override
  void initState() {
    super.initState();
    _startQuiz();
  }

  void _startQuiz() {
    if (globalVocabs.isEmpty) return;
    
    // Xáo trộn danh sách từ vựng hiện có
    quizList = List.from(globalVocabs)..shuffle();
    correctCount = 0;
    wrongCount = 0;
    currentIndex = 0;
    _generateQuestion();
  }

  void _generateQuestion() {
    // Nếu đã làm hết câu hỏi thì hiện bảng kết quả
    if (currentIndex >= quizList.length) {
      _showResultDialog();
      return;
    }
    
    final currentWord = quizList[currentIndex];
    final random = Random();
    
    // Tạo tỷ lệ 50% hiển thị nghĩa sai (nếu thư viện có nhiều hơn 1 từ)
    if (globalVocabs.length > 1 && random.nextBool()) {
      isMeaningCorrect = false;
      // Tìm một nghĩa của từ khác để làm đáp án sai
      var wrongVocab = globalVocabs[random.nextInt(globalVocabs.length)];
      while (wrongVocab.id == currentWord.id) {
        wrongVocab = globalVocabs[random.nextInt(globalVocabs.length)];
      }
      displayedMeaning = wrongVocab.meaning;
    } else {
      isMeaningCorrect = true;
      displayedMeaning = currentWord.meaning;
    }
    setState(() {});
  }

  void _checkAnswer(bool userChoice) {
    if (userChoice == isMeaningCorrect) {
      correctCount++;
    } else {
      wrongCount++;
    }
    currentIndex++;
    _generateQuestion();
  }

  // Hộp thoại hiển thị khi kết thúc số câu trả lời
  void _showResultDialog() {
    int total = correctCount + wrongCount;
    double accuracy = total == 0 ? 0 : (correctCount / total) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text('Kết thúc bài kiểm tra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tổng số câu: $total'),
            Text('✔️ Đúng: $correctCount', style: const TextStyle(color: Colors.green)),
            Text('❌ Sai: $wrongCount', style: const TextStyle(color: Colors.red)),
            Text('Tỷ lệ chính xác: ${accuracy.toStringAsFixed(1)}%'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _startQuiz(); // Bấm làm lại sẽ reset biến
              });
            },
            child: const Text('Làm lại'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Thoát về màn hình trước
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trắc nghiệm Đúng / Sai', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: quizList.isEmpty 
        ? const Center(child: Text('Vui lòng thêm từ vựng ở Trang chính trước khi kiểm tra!'))
        : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Thanh hiển thị điểm số
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text('✔️ Đúng: $correctCount', style: const TextStyle(color: Colors.white)), 
                    backgroundColor: Colors.green
                  ),
                  Chip(
                    label: Text('❌ Sai: $wrongCount', style: const TextStyle(color: Colors.white)), 
                    backgroundColor: Colors.orange
                  ),
                ],
              ),
              const Spacer(),
              
              // Khung hiển thị câu hỏi
              Text(
                quizList[currentIndex].word, 
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(displayedMeaning, style: const TextStyle(fontSize: 20)),
              ),
              const Spacer(),
              
              // Nút Đúng / Sai
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _checkAnswer(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Đúng', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _checkAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text('Sai', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
    );
  }
}