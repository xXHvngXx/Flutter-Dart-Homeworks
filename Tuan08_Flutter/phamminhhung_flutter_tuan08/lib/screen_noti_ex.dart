import 'package:flutter/material.dart';
import 'notification_service.dart';

class ScreenNotiEx extends StatelessWidget {
  const ScreenNotiEx({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService notificationService = NotificationService();
    // Lưu ý: Trong dự án thực tế, nên đưa init() ra ngoài hàm build (ví dụ: initState hoặc main) 
    // để tránh việc khởi tạo lại mỗi khi UI render lại.
    notificationService.init();

    return Scaffold(
      appBar: AppBar(title: const Text("Screen Noti Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút lệnh gửi thông báo tức thì
            ElevatedButton(
              onPressed: () {
                notificationService.showSimpleNotification(
                  id:0,
                  title:'Nhắc học từ vựng',
                  body:'Bạn đã học 5 từ mới hôm nay chưa?',
                );
              },
              child: const Text("Gửi thông báo nhắc học Ngoại ngữ"),
            ),
            const SizedBox(height: 20),
            
            // Nút lệnh lên lịch notification sau 2 phút
            ElevatedButton(
              onPressed: () {
                notificationService.scheduleNotificationAfter(
                  id:1,
                  delay: const Duration(seconds: 5),
                  title:'Uống nước',
                  body:'Nhắc uống nước đúng giờ',
                );
              },
              child: const Text("Gửi thông báo nhắc uống nước sau 2 phút"),
            ),
            const SizedBox(height: 20),
            
            // Nút lệnh hẹn giờ nhắc học Ngoại ngữ sau 10 phút (Đã bổ sung code)
            ElevatedButton(
              onPressed: () {
                notificationService.scheduleNotificationAfter(
                  id:2,
                  delay:const Duration(seconds: 10),
                  title: 'Ngoại ngữ',
                  body:'Đã đến giờ học 5 từ vựng mới rồi!',
                );
              },
              child: const Text("Hẹn giờ gửi thông báo học Ngoại ngữ sau 10 phút"),
            ),
          ],
        ),
      ),
    );
  }
}