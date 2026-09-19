import 'package:flutter/material.dart';

// 1. Widget con để hiển thị từng dòng trong ListView.builder
class ListItemNew extends StatelessWidget {
  final String title;
  final String content;
  final String dialogContent;
  final Function(String, String) function;

  const ListItemNew({
    super.key,
    required this.title,
    required this.content,
    required this.dialogContent,
    required this.function,
  });

  // Chọn icon tương ứng dựa theo tiêu đề
  IconData _getIconForTitle(String title) {
    if (title.contains("phần mềm")) return Icons.home;
    if (title.contains("thông tin") && !title.contains("An toàn")) return Icons.business;
    if (title.contains("Mạng")) return Icons.school;
    return Icons.security; // An toàn thông tin
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(
      fontSize: 20,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );

    return ListTile(
      leading: Icon(_getIconForTitle(title)),
      title: Text(title, style: textStyle),
      subtitle: Text(content),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        // Gọi hàm hiển thị dialog truyền từ ngoài vào
        function("Thông báo", "Bạn chọn $dialogContent");
      },
    );
  }
}

// 2. Widget chính chứa ListView.builder
class MyListViewBuilder extends StatefulWidget {
  const MyListViewBuilder({super.key});

  @override
  State<MyListViewBuilder> createState() => _MyListViewBuilderState();
}

class _MyListViewBuilderState extends State<MyListViewBuilder> {
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  static const List<String> dsTieuDe = [
    'Công nghệ phần mềm',
    'Hệ thống thông tin',
    'Mạng máy tính',
    'An toàn thông tin',
  ];

  static const List<String> dsNoiDung = [
    'Phát triển các ứng dụng giải quyết các vấn đề thực tế',
    'Phát triển các kỹ thuật xử lý thông tin trong tổ chức',
    'Xử lý các vấn đề liên quan đến mạng máy tính',
    'Thiết kế và đảm bảo an toàn cho hệ thống máy tính',
  ];

  static const List<String> dsNoiDungTB = ['CNPM', 'HTTT', 'MMT', 'BMTT'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView Demo"),
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: dsTieuDe.length,
        itemBuilder: (BuildContext context, int index) {
          return ListItemNew(
            title: dsTieuDe[index],
            content: dsNoiDung[index],
            dialogContent: dsNoiDungTB[index],
            function: _showDialog,
          );
        },
      ),
    );
  }
}