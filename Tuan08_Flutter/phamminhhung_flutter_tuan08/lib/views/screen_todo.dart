import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/file_services.dart';
import '../notification_service.dart'; 

class ScreenTodo extends StatefulWidget {
  const ScreenTodo({super.key});

  @override
  State<ScreenTodo> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<ScreenTodo> {
  final TextEditingController controller = TextEditingController();
  final FileService fileService = FileService();
  
  // 1. KHỞI TẠO BIẾN DỊCH VỤ THÔNG BÁO
  final NotificationService notificationService = NotificationService(); 

  List<Todo> todos = [];
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    todos = await fileService.loadTodos();
    setState(() {});
  }

  // HÀM LƯU CÔNG VIỆC VÀ THIẾT LẬP THÔNG BÁO (BÀI TẬP 3)
  void addTodo() async {
    if (controller.text.isEmpty || selectedTime == null) return;

    final todo = Todo(title: controller.text, time: selectedTime!);

    // Lưu vào file và update List
    todos.add(todo);
    await fileService.saveTodos(todos);

    // ================= XỬ LÝ BÀI TẬP 3 =================
    
    // Hành động 1: Hiển thị notification tức thì báo đã thêm
    await notificationService.showSimpleNotification(
      id: todos.length, // id khác nhau để thông báo không đè lên nhau
      title: "Đã thêm lịch thành công ✅",
      body: "Công việc: ${todo.title}",
    );

    // Hành động 2: Hẹn giờ thông báo theo thời gian đã chọn
    // Tính khoảng thời gian từ bây giờ đến lúc chọn
    final delay = selectedTime!.difference(DateTime.now());
    
    // Chỉ hẹn giờ nếu thời gian chọn lớn hơn hiện tại (tương lai)
    if (delay.inSeconds > 0) {
      await notificationService.scheduleNotificationAfter(
        id: todos.length,
        delay:delay,
        title: 'Nhắc việc Todo',
        body: 'Đến giờ làm: ${todo.title}',
      );
    } else {
      // Báo lỗi nhẹ nếu người dùng lỡ chọn giờ trong quá khứ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Giờ chọn đã qua, lịch nhắc hẹn giờ sẽ không được đặt!")),
        );
      }
    }
    // ===================================================

    // Reset UI
    controller.clear();
    selectedTime = null;

    setState(() {});
  }

  // CHỌN NGÀY + GIỜ
  void pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        selectedTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {});
      }
    }
  }

  String formatTime(DateTime time) {
    return DateFormat("dd/MM/yyyy HH:mm").format(time);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade100,
    ];

    Color getTextColor(Color bg) {
      return bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Todo App"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Tên công việc",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? "Chưa chọn thời gian"
                        : formatTime(selectedTime!),
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Chọn thời gian",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: addTodo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.blue, width: 1.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Lưu"),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final t = todos[index];
                  final Color bgColor = colors[index % colors.length];

                  return Card(
                    color: bgColor,
                    child: ListTile(
                      leading: Icon(
                        Icons.task,
                        color: getTextColor(bgColor),
                      ),
                      title: Text(
                        t.title,
                        style: TextStyle(
                          color: getTextColor(bgColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        formatTime(t.time),
                        style: TextStyle(
                          color: getTextColor(bgColor).withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}