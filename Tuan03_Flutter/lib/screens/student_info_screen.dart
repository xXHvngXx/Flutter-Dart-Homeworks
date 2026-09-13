import 'package:flutter/material.dart';

class StudentInfoScreen extends StatelessWidget {
  const StudentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004080),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Thông tin sinh viên',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/student.jpg',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 140,
                      height: 140,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 70, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Họ và tên: Nguyễn Văn A',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A2A8F),
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoRow('MSSV: ', '2001221234'),
            _buildInfoRow('Lớp: ', '13DHTH02'),
            _buildInfoRow('Khóa: ', '13 Đại học'),
            _buildInfoRow('Ngành: ', 'Công nghệ thông tin'),
            _buildInfoRow('Trường: ', 'Đại học Công Thương\nThành phố Hồ Chí Minh'),

            const SizedBox(height: 40),

            Center(
              child: SizedBox(
                width: 160,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Trở về',
                    style: TextStyle(
                      color: Color(0xFF6B6B99),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE53935),
            height: 1.3,
          ),
          children: [
            TextSpan(text: label),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}