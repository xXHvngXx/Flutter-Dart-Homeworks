import 'package:flutter/material.dart';

void main() {
  runApp(const HuitApp());
}

class HuitApp extends StatelessWidget {
  const HuitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HUIT - Cơ Sở Vật Chất',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005A9E),
          primary: const Color(0xFF005A9E),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const CampusOverviewPage(),
    );
  }
}

class CampusOverviewPage extends StatefulWidget {
  const CampusOverviewPage({super.key});

  @override
  State<CampusOverviewPage> createState() => _CampusOverviewPageState();
}

class _CampusOverviewPageState extends State<CampusOverviewPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MainCampusScreen(),
    LibraryScreen(),
    SportsAndLabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: const Color(0xFF005A9E),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'HUIT CAMPUS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          indicatorColor: const Color(0xFF005A9E).withOpacity(0.15),
          elevation: 0,
          height: 65,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.location_city_outlined),
              selectedIcon: Icon(Icons.location_city_rounded, color: Color(0xFF005A9E)),
              label: 'Trụ sở chính',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_library_outlined),
              selectedIcon: Icon(Icons.local_library_rounded, color: Color(0xFF005A9E)),
              label: 'Thư viện',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_soccer_outlined),
              selectedIcon: Icon(Icons.sports_soccer_rounded, color: Color(0xFF005A9E)),
              label: 'Thể thao & Lab',
            ),
          ],
        ),
      ),
    );
  }
}

class MainCampusScreen extends StatelessWidget {
  const MainCampusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          _buildBannerCard(
            imageUrl: 'https://picsum.photos/800/400?random=1',
            tag: 'Cơ Sở Chinh',
          ),
          const SizedBox(height: 20),
          const Text(
            'Trụ Sở Chính HUIT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoChip(
            icon: Icons.location_on_rounded,
            label: '140 Lê Trọng Tấn, P. Tây Thạnh, Q. Tân Phú, TP. HCM',
          ),
          const SizedBox(height: 20),
          _buildGridStats([
            _StatItem(Icons.meeting_room_rounded, '100%', 'Phòng Máy Lạnh'),
            _StatItem(Icons.wifi_rounded, 'Wifi 6', 'Phủ Sóng Toàn Khu'),
            _StatItem(Icons.videocam_rounded, 'Smart UI', 'Thiết Bị Hiện Đại'),
          ]),
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'Tổng quan giảng đường',
            content:
                'Trụ sở chính của Trường Đại học Công thương TP.HCM (HUIT) tự hào sở hữu hệ thống hạ tầng và cơ sở vật chất được đầu tư quy mô, hiện đại hàng đầu. Toàn bộ các dãy nhà giảng đường được thiết kế tối ưu ánh sáng tự nhiên, trang bị 100% hệ thống điều hòa không khí, máy chiếu công suất lớn, màn hình tương tác thông minh cùng hệ thống âm thanh trợ giảng đạt chuẩn quốc tế. Không gian học tập được kết nối liên hoàn với khuôn viên cây xanh tươi mát, các khu vực ghế đá nghỉ chân và khu vực làm việc nhóm ngoài trời, mang lại môi trường học tập năng động, thoải mái và tiện nghi tối đa cho sinh viên trong suốt quá trình theo học.',
          ),
        ],
      ),
    );
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          _buildBannerCard(
            imageUrl: 'https://picsum.photos/800/400?random=2',
            tag: 'Trung Tâm Học Liệu',
          ),
          const SizedBox(height: 20),
          const Text(
            'Thư Viện Số & Learning Commons',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoChip(
            icon: Icons.access_time_filled_rounded,
            label: 'Phục vụ: 07:30 - 20:30 (Thứ 2 - Thứ 7)',
          ),
          const SizedBox(height: 20),
          _buildGridStats([
            _StatItem(Icons.menu_book_rounded, '50.000+', 'Đầu Sách Số'),
            _StatItem(Icons.computer_rounded, '200+', 'Máy Tính Tra Cứu'),
            _StatItem(Icons.groups_rounded, '15+', 'Phòng Thảo Luận'),
          ]),
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'Không gian học tập mở',
            content:
                'Thư viện HUIT được xây dựng và phát triển theo mô hình Trung tâm Học liệu Mở (Learning Commons) hiện đại, đáp ứng tiêu chuẩn chất lượng cao của các trường đại học tiên tiến. Với tổng diện tích rộng lớn được chia thành nhiều phân khu chức năng riêng biệt: khu vực đọc sách yên tĩnh, khu làm việc nhóm linh hoạt được trang bị bảng tương tác, và hệ thống phòng máy tính tra cứu Internet tốc độ cao. Thư viện sở hữu hàng chục ngàn đầu sách in, giáo trình chuyên ngành cùng quyền truy cập vào các cơ sở dữ liệu tạp chí khoa học quốc tế uy tín. Đây không chỉ là nơi tra cứu tài liệu mà còn là không gian truyền cảm hứng sáng tạo và nghiên cứu độc lập cho sinh viên.',
          ),
        ],
      ),
    );
  }
}

class SportsAndLabScreen extends StatelessWidget {
  const SportsAndLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          _buildBannerCard(
            imageUrl: 'https://picsum.photos/800/400?random=3',
            tag: 'Thực Hành & Thể Thao',
          ),
          const SizedBox(height: 20),
          const Text(
            'Phòng Lab & Khu Thể Thao',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoChip(
            icon: Icons.fitness_center_rounded,
            label: 'Đa năng: Sân Cầu Lông, Bóng Rổ, Gym & Lab CNTT',
          ),
          const SizedBox(height: 20),
          _buildGridStats([
            _StatItem(Icons.memory_rounded, 'i7 / RTX', 'Cấu Hình Lab High-End'),
            _StatItem(Icons.sports_basketball_rounded, '1000m²', 'Nhà Thi Đấu'),
            _StatItem(Icons.security_rounded, '24/7', 'Giám Sát An Ninh'),
          ]),
          const SizedBox(height: 20),
          _buildSectionCard(
            title: 'Hạ tầng thực hành & Rèn luyện',
            content:
                'Nhằm đảm bảo sự phát triển toàn diện cả về trí tuệ lẫn thể chất cho sinh viên, HUIT đầu tư đồng bộ hệ thống các phòng thực hành máy tính chuyên dụng có cấu hình cao, trang bị bộ vi xử lý và card đồ họa thế hệ mới, đáp ứng hoàn hảo nhu cầu thực hành Lập trình, Công nghệ phần mềm, Đồ họa 3D và Trí tuệ nhân tạo. Song song đó, nhà thi đấu đa năng cùng hệ thống sân thể thao ngoài trời (bao gồm sân bóng đá, cầu lông, bóng rổ) được quy hoạch bài bản, đạt tiêu chuẩn an toàn. Đây là nơi diễn ra các hoạt động rèn luyện thể chất, giải đấu sinh viên sôi nổi, giúp sinh viên giải tỏa căng thẳng sau những giờ học lý thuyết trên lớp.',
          ),
        ],
      ),
    );
  }
}

Widget _buildBannerCard({required String imageUrl, required String tag}) {
  return Container(
    height: 210,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            height: 210,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF005A9E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoChip({required IconData icon, required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF005A9E)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF005A9E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildGridStats(List<_StatItem> items) {
  return Row(
    children: items
        .map(
          (item) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(item.icon, size: 22, color: const Color(0xFF005A9E)),
                  const SizedBox(height: 6),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
  );
}

Widget _buildSectionCard({required String title, required String content}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF475569),
          ),
        ),
      ],
    ),
  );
}

class _StatItem {
  final IconData icon;
  final String value;
  final String title;

  _StatItem(this.icon, this.value, this.title);
}