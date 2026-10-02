import 'package:flutter/material.dart';

void main() {
  runApp(const EWalletApp());
}

class EWalletApp extends StatelessWidget {
  const EWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Wallet',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFEBEBEB),
      ),
      home: const WalletHomeScreen(),
    );
  }
}

class WalletHomeScreen extends StatefulWidget {
  const WalletHomeScreen({super.key});

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  int _currentCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildCardSection(),
              const SizedBox(height: 12),
              _buildPageIndicator(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 28),
              _buildMenuCard(
                icon: Icons.bar_chart_rounded,
                iconColor: Colors.deepPurple,
                title: 'Statistics',
                subtitle: 'Payment and Income',
              ),
              const SizedBox(height: 14),
              _buildMenuCard(
                icon: Icons.swap_horiz_rounded,
                iconColor: Colors.blue,
                title: 'Transactions',
                subtitle: 'Transaction History',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFE91E63),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.attach_money_rounded, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              SizedBox(width: 40),
              SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Text(
              'My',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Cards',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.black87, size: 20),
        ),
      ],
    );
  }

  Widget _buildCardSection() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF8C62FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8C62FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: const [
              Text(
                'Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '\$5250.25',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '12345678',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '10/24',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == _currentCardIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.grey.shade800 : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.send_rounded,
          iconColor: Colors.orange,
          label: 'Send',
        ),
        _buildActionButton(
          icon: Icons.credit_card_rounded,
          iconColor: Colors.blue,
          label: 'Pay',
        ),
        _buildActionButton(
          icon: Icons.receipt_long_rounded,
          iconColor: Colors.green,
          label: 'Bills',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black45,
            size: 16,
          ),
        ],
      ),
    );
  }
}