import 'package:flutter/material.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF2575FC),
      ),
      home: const MoodHomeScreen(),
    );
  }
}

class MoodHomeScreen extends StatefulWidget {
  const MoodHomeScreen({super.key});

  @override
  State<MoodHomeScreen> createState() => _MoodHomeScreenState();
}

class _MoodHomeScreenState extends State<MoodHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2675EC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildMoodSection(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F5F9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSectionHeader('Exercises'),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildExerciseCard(
                            title: 'Speaking Skillz',
                            subtitle: '16 Exercises',
                            icon: Icons.favorite_rounded,
                            iconBgColor: Colors.orange,
                          ),
                          const SizedBox(height: 12),
                          _buildExerciseCard(
                            title: 'Reading Skills',
                            subtitle: '8 Exercises',
                            icon: Icons.person_rounded,
                            iconBgColor: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildExerciseCard(
                            title: 'Writing Skills',
                            subtitle: '20 Exercises',
                            icon: Icons.star_rounded,
                            iconBgColor: Colors.pink,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF2F5F9),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xFF2675EC),
          unselectedItemColor: Colors.grey.shade400,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 24),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 26),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: const [
            Text(
              'Hi, Jared!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '23 Jan, 2021',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, color: Colors.white, size: 20),
          SizedBox(width: 10),
          Text(
            'Search',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection() {
    final moods = [
      {'emoji': '🙁', 'label': 'Bad'},
      {'emoji': '🙂', 'label': 'Fine'},
      {'emoji': '😁', 'label': 'Well'},
      {'emoji': '🥳', 'label': 'Excellent'},
    ];

    return Column(
      children: [
        _buildSectionHeader('How do you feel?', isWhite: true),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: moods.map((item) {
            return Column(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      item['emoji']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isWhite = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isWhite ? Colors.white : const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.more_horiz_rounded,
          color: isWhite ? Colors.white70 : Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.more_horiz_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}