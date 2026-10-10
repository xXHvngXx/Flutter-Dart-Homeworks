import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DailyTask {
  String id;
  String name;
  DateTime reminderTime;
  bool isCompleted;

  DailyTask({
    required this.id,
    required this.name,
    required this.reminderTime,
    this.isCompleted = false,
  });

  // Chuyển object thành chuỗi để lưu file
  String toFileString() {
    return "$id|$name|${reminderTime.toIso8601String()}|$isCompleted";
  }

  // Khôi phục object từ chuỗi
  static DailyTask fromString(String line) {
    final parts = line.split("|");
    return DailyTask(
      id: parts[0],
      name: parts[1],
      reminderTime: DateTime.parse(parts[2]),
      isCompleted: parts[3] == 'true',
    );
  }
}

class DailyTaskFileService {
  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/daily_tasks.txt');
  }

  Future<void> saveTasks(List<DailyTask> tasks) async {
    final file = await _file;
    String data = tasks.map((e) => e.toFileString()).join("\n");
    await file.writeAsString(data);
  }

  Future<List<DailyTask>> loadTasks() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      return content
          .split("\n")
          .where((e) => e.trim().isNotEmpty)
          .map((e) => DailyTask.fromString(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}