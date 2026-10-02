import 'package:flutter/material.dart';

class TopicInfoScreen extends StatelessWidget {
  const TopicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004080),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Thông tin đề tài khóa luận',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment,
                  size: 70,
                  color: Color(0xFF004080),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Xây dựng ứng dụng quản lý bán hàng đa nền tảng bằng Flutter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A2A8F),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoRow('Mã đề tài: ', 'DT2026_CNPM01', Colors.black87),
            _buildInfoRow('Chuyên ngành: ', 'Công nghệ phần mềm', Colors.black87),
            _buildInfoRow('Giảng viên HD: ', 'TS. Nguyễn Văn B', const Color(0xFF1976D2)),
            _buildInfoRow('Số SV tối đa: ', '02 sinh viên', const Color(0xFFE53935)),

            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            const Text(
              'Yêu cầu đề tài:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Có kiến thức nền tảng về Flutter & Dart.\n'
              '• Hiểu biết về Restful API và kết nối CSDL SQL Server / Firebase.\n'
              '• Sử dụng thành thạo Git để quản lý mã nguồn nhóm.\n'
              '• Hoàn thành ứng dụng đúng tiến độ và có báo cáo khóa luận.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            Center(
              child: SizedBox(
                width: 160,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
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

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, height: 1.3),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}