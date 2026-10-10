import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // =============== INIT ===============
  Future<void> init() async {
    // 1. Init timezone
    tz.initializeTimeZones();
    // FIX cứng timezone VN
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    // 2. Android settings
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    // 3. Init plugin
    await _plugin.initialize(settings);

    // 4. Xin quyền notification
    await _requestPermission();
  }

  // ================= REQUEST PERMISSION =================
  Future<void> _requestPermission() async {
    // Xin quyền hiển thị thông báo
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    // Xin quyền đặt lịch chính xác (Exact Alarms) để fix lỗi sập app
    final androidImplementation = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  static AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  
  /// Lấy danh sách các thông báo đang chờ nổ
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  /// Hủy một thông báo cụ thể bằng ID
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  // =============================================================

  // Hàm tái sử dụng cho thiết lập thời gian để bật notification zonedSchedule
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required AndroidNotificationDetails androidDetails,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Hàm gửi thông báo tức thì (Đã cập nhật tham số)
  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = _createAndroidDetails(
      channelId: 'learn_english_channel',
      channelName: 'Học Anh Văn',
    );

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(android: details),
    );
  }

  /// Đặt lịch sau 1 khoảng thời gian delay (Đã cập nhật tham số)
  Future<void> scheduleNotificationAfter({
    required int id,
    required Duration delay,
    required String title,
    required String body,
  }) async {
    final details = _createAndroidDetails(
      channelId: 'vocab_channel',
      channelName: 'Từ Vựng',
      channelDescription: 'Nhắc học từ vựng mới',
    );

    final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);

    await _scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      androidDetails: details,
    );
  }
}