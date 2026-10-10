import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_task.dart';
import 'add_task_screen.dart';
import '../notification_service.dart'; 

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<DailyTask> tasks = [];
  final DailyTaskFileService fileService = DailyTaskFileService();
  final NotificationService notiService = NotificationService(); // Đã dùng Singleton

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    tasks = await fileService.loadTasks();
    setState(() {});
  }

  void _saveData() async {
    await fileService.saveTasks(tasks);
  }

  // Hàm thiết lập thông báo khi bấm icon chuông
  void _scheduleReminder(DailyTask task) {
    final delay = task.reminderTime.difference(DateTime.now());
    
    if (delay.inSeconds > 0) {
      notiService.scheduleNotificationAfter(
        id: task.id.hashCode,
        delay: delay,
        title: 'Đến giờ làm nhiệm vụ!',
        body: task.name,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thiết lập thông báo cho: ${task.name}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ nhắc đã qua, không thể đặt lịch!')),
      );
    }
  }

  // Xử lý khi tick vào Checkbox
  void _onTaskChecked(int index, bool? value) {
    if (value == true && !tasks[index].isCompleted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Xác nhận nhiệm vụ này đã hoàn thành?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Không")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Có")),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true) {
          setState(() {
            tasks[index].isCompleted = true;
          });
          _saveData(); // Lưu lại file
          
          // Đếm số lượng đã hoàn thành và gửi thông báo
          int completedCount = tasks.where((t) => t.isCompleted).length;
          notiService.showSimpleNotification(
            id: 9999, // ID cố định để thông báo báo cáo tiến độ đè lên nhau
            title: "Thống kê nhiệm vụ",
            body: "Bạn đã hoàn thành $completedCount nhiệm vụ. Tuyệt vời!",
          );
        }
      });
    } else if (value == false) {
      // Cho phép bỏ tick nếu lỡ bấm nhầm
      setState(() { tasks[index].isCompleted = false; });
      _saveData();
    }
  }

  // Mở màn hình thêm và nhận dữ liệu trả về
  void _navigateToAddScreen() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (newTask != null && newTask is DailyTask) {
      setState(() {
        tasks.add(newTask);
      });
      _saveData(); // Lưu vào file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nhiệm vụ mỗi ngày', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (v) => _onTaskChecked(index, v),
                activeColor: Colors.blue,
              ),
              title: Text(
                task.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Nhắc lúc ${DateFormat('HH:mm').format(task.reminderTime)}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black87),
                onPressed: () => _scheduleReminder(task),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }
}