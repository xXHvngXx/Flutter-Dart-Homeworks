import 'package:flutter/material.dart';

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFE2E0EC),
      ),
      home: const MedicalHomeScreen(),
    );
  }
}

class MedicalHomeScreen extends StatelessWidget {
  const MedicalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E0EC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildBannerCard(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCategoryList(),
              const SizedBox(height: 24),
              _buildDoctorHeader(),
              const SizedBox(height: 16),
              _buildDoctorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: const [
            Text(
              'Hello,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Mitch Koko',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFC8C2DE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.black87,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9C0D3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFB0A4E3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.medication_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const Text(
                  'How do you feel?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Fill out your medical card right now',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9070D8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC6E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, color: Colors.black54, size: 22),
          SizedBox(width: 12),
          Text(
            'How can we help you?',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildCategoryChip('Dentist', Icons.clean_hands_rounded),
          const SizedBox(width: 12),
          _buildCategoryChip('Surgeon', Icons.local_hospital_rounded),
          const SizedBox(width: 12),
          _buildCategoryChip('Pharmacy', Icons.medical_services_rounded),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC6E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B58A6), size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Doctor list',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorList() {
    return Row(
      children: [
        Expanded(
          child: _buildDoctorCard(
            name: 'Dr. Mitch Koko',
            specialty: 'Psychologist 7 y.e.',
            rating: '4.4',
            imageUrl: 'https://picsum.photos/200?random=10',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildDoctorCard(
            name: 'Dr. Steve Jobs',
            specialty: 'Surgeon 7 y.e.',
            rating: '5.0',
            imageUrl: 'https://picsum.photos/200?random=11',
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required String rating,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC6E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            specialty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}