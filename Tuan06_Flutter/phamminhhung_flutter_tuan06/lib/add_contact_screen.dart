import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _avatar;

  Future<void> _pickImage(ImageSource source) async {
    final status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.photos.request();

    if (status.isGranted || await Permission.storage.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _avatar = File(pickedFile.path);
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chưa được cấp quyền truy cập ảnh!')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ Thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp từ Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên và số điện thoại không được để trống!'),
        ),
      );
      return;
    }

    final newContact = Contact(
      name: Name(first: name),
      phones: [Phone(phone)],
      emails: email.isNotEmpty ? [Email(email)] : [],
      photo: _avatar != null ? await _avatar!.readAsBytes() : null,
    );

    try {
      await newContact.insert();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Danh bạ đã được lưu thành công!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu danh bạ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm danh bạ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                child: _avatar == null
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveContact,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}