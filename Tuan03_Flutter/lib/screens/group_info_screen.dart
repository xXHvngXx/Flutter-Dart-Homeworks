import 'package:flutter/material.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách 3 thành viên theo yêu cầu đề bài
    final List<Map<String, String>> members = [
      {
        'mssv': '2001220001',
        'name': 'Phạm Minh Hưng',
        'role': 'Nhóm trưởng',
        'avatar': 'assets/images/member1.jpg',
      },
      {
        'mssv': '2001220002',
        'name': 'Nguyễn Văn Kiệt',
        'role': 'Thành viên',
        'avatar': 'assets/images/member2.jpg',
      },
      {
        'mssv': '2001220003',
        'name': 'Trần Trung Kiên',
        'role': 'Thành viên',
        'avatar': 'assets/images/member3.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004080),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Thông tin nhóm',
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
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups,
                  size: 70,
                  color: Color(0xFF004080),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text(
                'NHÓM PHÁT TRIỂN ỨNG DỤNG FLUTTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A2A8F),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoRow('Mã nhóm: ', 'GR_FLUTTER_01', Colors.black87),
            _buildInfoRow('Số lượng thành viên: ', '${members.length} người', const Color(0xFFE53935)),

            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),

            const Text(
              'Danh sách thành viên:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isLeader = member['role'] == 'Nhóm trưởng';

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isLeader ? const Color(0xFF004080) : Colors.grey[300]!,
                      width: isLeader ? 1.5 : 0.8,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            member['avatar']!,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 55,
                                height: 55,
                                color: isLeader ? const Color(0xFFE8EAF6) : Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: isLeader ? const Color(0xFF004080) : Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isLeader ? const Color(0xFF2A2A8F) : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'MSSV: ${member['mssv']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLeader ? const Color(0xFFE53935) : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member['role']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isLeader ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Nút Trở về
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
      padding: const EdgeInsets.only(bottom: 10.0),
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
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}