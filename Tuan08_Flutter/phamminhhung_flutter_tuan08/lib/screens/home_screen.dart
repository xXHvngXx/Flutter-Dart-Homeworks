// file: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../notification_service.dart';
import 'practice_screen.dart';
import 'reminder_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final NotificationService _notiService = NotificationService();

  void saveAndSchedule() {
    if (wordController.text.isEmpty || meaningController.text.isEmpty) return;

    final newId = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Tạo ID duy nhất
    final word = wordController.text;
    final meaning = meaningController.text;

    // Lưu vào danh sách
    globalVocabs.add(Vocabulary(id: newId, word: word, meaning: meaning));

    // Lên lịch sau 10 phút (Dùng 10 giây để test nhanh nếu muốn)
    _notiService.scheduleNotificationAfter(
      id: newId,
      delay: const Duration(minutes: 10), 
      title: 'Ôn từ vựng mới!',
      body: '$word - $meaning',
    );

    // Hiển thị SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu và lên lịch nhắc học từ sau 10 phút'),
        backgroundColor: Colors.black87,
        duration: Duration(seconds: 2),
      ),
    );

    wordController.clear();
    meaningController.clear();
    FocusScope.of(context).unfocus(); // Đóng bàn phím
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng dụng học từ vựng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      drawer: const AppDrawer(), // Gọi Drawer dung chung
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(labelText: 'Từ'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: meaningController,
              decoration: const InputDecoration(labelText: 'Nghĩa'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveAndSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Lưu & Nhắc học sau 10 phút'),
            )
          ],
        ),
      ),
    );
  }
}

// ============== DRAWER MENU ==============
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text('Trợ lý học từ vựng', style: TextStyle(fontSize: 18)),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chính'),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Học từ'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Kiểm tra từ'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Lịch nhắc'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReminderScreen())),
          ),
        ],
      ),
    );
  }
}