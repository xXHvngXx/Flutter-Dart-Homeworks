// file: lib/screens/reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final NotificationService _notiService = NotificationService();
  List<PendingNotificationRequest> pendingList = [];

  @override
  void initState() {
    super.initState();
    loadPendingNotifications();
  }

  void loadPendingNotifications() async {
    final list = await _notiService.getPendingNotifications();
    setState(() {
      pendingList = list;
    });
  }

  void cancelReminder(int id) async {
    await _notiService.cancelNotification(id);
    loadPendingNotifications(); // Cập nhật lại danh sách sau khi xóa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch nhắc', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: pendingList.isEmpty
          ? const Center(child: Text('Không có lịch nhắc nào'))
          : ListView.builder(
              itemCount: pendingList.length,
              itemBuilder: (context, index) {
                final item = pendingList[index];
                return ListTile(
                  leading: const Icon(Icons.alarm, color: Colors.grey),
                  title: Text(item.title ?? 'Không có tiêu đề'),
                  subtitle: Text(item.body ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => cancelReminder(item.id),
                  ),
                );
              },
            ),
    );
  }
}