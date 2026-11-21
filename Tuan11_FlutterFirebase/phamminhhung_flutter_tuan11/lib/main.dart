import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

import 'bai1_auth.dart';
import 'bai2_auth.dart';
import 'bai3_auth.dart';
import 'btvn.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuScreen(),
  ));
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Bài tập 1: Firebase Authentication', const AuthScreen()),
      ('Bài tập 2: Upload File Storage', const FileUploadScreen()),
      ('Bài tập 3: Quản lý Sản phẩm', const ProductListScreen()),
      ('BTVN: Ví điện tử Zhippay', const ZhippayApp()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực hành Chương 7 - Firebase'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => items[index].$2),
              );
            },
            child: Text(
              items[index].$1,
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}