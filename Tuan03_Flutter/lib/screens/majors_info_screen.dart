import 'package:flutter/material.dart';

class MajorsInfoScreen extends StatelessWidget {
  const MajorsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF004080),
          leading: IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          title: const Text(
            'Giới thiệu Ngành học - HUIT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            tabs: [
              Tab(text: 'Công nghệ Thông tin'),
              Tab(text: 'An toàn Thông tin'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MajorDetailView(
              majorName: 'Ngành Công nghệ Thông tin',
              majorCode: '7480201',
              logoPath: 'assets/images/cntt_logo.png',
              description:
                  'Ngành Công nghệ Thông tin đào tạo cử nhân có kiến thức toàn diện về phát triển phần mềm, hệ thống thông tin, mạng máy tính và trí tuệ nhân tạo (AI).\n\n'
                  'Sinh viên được trang bị kỹ năng lập trình đa nền tảng (Web, Mobile, Desktop), thiết kế cơ sở dữ liệu và quản trị dự án phần mềm theo tiêu chuẩn công nghiệp.',
              careerOpportunities: [
                'Lập trình viên Software / Web / Mobile Developer',
                'Kĩ sư Kiểm thử phần mềm (QA/QC Tester)',
                'Kĩ sư Dữ liệu & AI (Data / AI Engineer)',
                'Chuyên viên Quản trị Hệ thống & CSDL',
              ],
            ),
            _MajorDetailView(
              majorName: 'Ngành An toàn Thông tin',
              majorCode: '7480202',
              logoPath: 'assets/images/attt_logo.png',
              description:
                  'Ngành An toàn Thông tin tập trung đào tạo chuyên sâu về bảo mật hệ thống, mã hóa dữ liệu, phòng chống tấn công mạng và rà quét lỗ hổng bảo mật.\n\n'
                  'Chương trình học giúp sinh viên làm chủ các kỹ thuật kiểm thử xâm nhập (Penetration Testing), giám sát an ninh mạng (SOC) và phân tích mã độc.',
              careerOpportunities: [
                'Chuyên gia Kiểm thử An ninh mạng (Penetraster / Ethical Hacker)',
                'Kĩ sư Giám sát & Phân tích An ninh mạng (SOC Analyst)',
                'Chuyên viên Quản trị Bảo mật Hệ thống',
                'Tư vấn & Thiết kế Giải pháp Bảo mật CNTT',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MajorDetailView extends StatelessWidget {
  final String majorName;
  final String majorCode;
  final String logoPath;
  final String description;
  final List<String> careerOpportunities;

  const _MajorDetailView({
    required this.majorName,
    required this.majorCode,
    required this.logoPath,
    required this.description,
    required this.careerOpportunities,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                logoPath,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    width: double.infinity,
                    color: const Color(0xFFE8EAF6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.school, size: 60, color: Color(0xFF004080)),
                        SizedBox(height: 8),
                        Text(
                          'Khoa Công nghệ Thông tin - HUIT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004080),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            majorName,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A2A8F),
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              children: [
                const TextSpan(
                  text: 'Mã ngành: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: majorCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(thickness: 1),
          const SizedBox(height: 12),

          const Text(
            'Giới thiệu tổng quan:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Cơ hội nghề nghiệp:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: careerOpportunities
                .map(
                  (job) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Color(0xFF004080),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 30),

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
    );
  }
}