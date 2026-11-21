import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ZhippayApp());
}

class ZhippayApp extends StatelessWidget {
  const ZhippayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zhippay',
      theme: ThemeData(
        primaryColor: const Color(0xFF5C4CE6),
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C4CE6)),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const MainWalletShell();
          }
          return const OnboardingScreen();
        },
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5C4CE6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 220,
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '\$4,5790.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Your next generation of\nfinancial platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2C),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Simple user experience meets personal finance of the future backed by decentralized finance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 6,
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WalletAuthScreen(isLogin: false),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Sign up to zhippay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WalletAuthScreen(isLogin: true),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account? Sign in',
                  style: TextStyle(color: primaryPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletAuthScreen extends StatefulWidget {
  final bool isLogin;
  const WalletAuthScreen({super.key, required this.isLogin});

  @override
  State<WalletAuthScreen> createState() => _WalletAuthScreenState();
}

class _WalletAuthScreenState extends State<WalletAuthScreen> {
  late bool _isLogin;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Vui lòng nhập Email và Mật khẩu');
      return;
    }

    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final displayName = name.isEmpty ? email.split('@')[0] : name;
        await cred.user?.updateDisplayName(displayName);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'uid': cred.user!.uid,
          'name': displayName,
          'email': email,
          'balance': 2108.22,
          'points': 6350,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? 'Lỗi xác thực');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Nhập email của bạn để nhận liên kết đặt lại mật khẩu');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnack('Đã gửi email khôi phục mật khẩu tới $email');
    } catch (e) {
      _showSnack('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5C4CE6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'zhippay',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'Welcome back' : 'Create Wallet Account',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            if (!_isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_isLogin)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: primaryPurple),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isLogin ? 'Sign In' : 'Sign Up',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(
                _isLogin
                    ? 'Don\'t have an account? Sign up'
                    : 'Already have an account? Sign in',
                style: const TextStyle(color: primaryPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainWalletShell extends StatefulWidget {
  const MainWalletShell({super.key});

  @override
  State<MainWalletShell> createState() => _MainWalletShellState();
}

class _MainWalletShellState extends State<MainWalletShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _ensureUserDocument();
  }

  Future<void> _ensureUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName ?? user.email?.split('@')[0] ?? 'User',
        'email': user.email ?? '',
        'balance': 2108.22,
        'points': 6350,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      const WalletCardScreen(),
      const StatisticScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5C4CE6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Statistic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDocStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    final txStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();

    const primaryPurple = Color(0xFF5C4CE6);
    final moneyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: userDocStream,
        builder: (context, userSnap) {
          final userData =
              userSnap.data?.data() as Map<String, dynamic>? ?? {};
          final balance = (userData['balance'] ?? 0.0).toDouble();
          final points = userData['points'] ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'zhippay',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2C),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.local_offer,
                                  size: 16, color: primaryPurple),
                              SizedBox(width: 4),
                              Text(
                                'rewards',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_none, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A5AE0), Color(0xFF4C3AE3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total balance',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            moneyFormat.format(balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$points points >',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionBtn(
                            icon: Icons.add_circle_outline,
                            label: 'Top Up',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoneyActionScreen(
                                  mode: MoneyActionMode.topUp,
                                  currentBalance: balance,
                                ),
                              ),
                            ),
                          ),
                          _buildActionBtn(
                            icon: Icons.swap_horiz,
                            label: 'Transfer',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoneyActionScreen(
                                  mode: MoneyActionMode.transfer,
                                  currentBalance: balance,
                                ),
                              ),
                            ),
                          ),
                          _buildActionBtn(
                            icon: Icons.arrow_circle_down,
                            label: 'Withdraw',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MoneyActionScreen(
                                  mode: MoneyActionMode.withdraw,
                                  currentBalance: balance,
                                ),
                              ),
                            ),
                          ),
                          _buildActionBtn(
                            icon: Icons.history,
                            label: 'History',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFEDEAFE),
                        child: Icon(Icons.rocket_launch, color: primaryPurple),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upgrade Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              'Upgrade account for more features',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Transfer again',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 78,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildContactItem(
                        context,
                        name: 'Add new',
                        isAdd: true,
                        balance: balance,
                      ),
                      _buildContactItem(
                        context,
                        name: 'Skyler',
                        balance: balance,
                      ),
                      _buildContactItem(
                        context,
                        name: 'Andrew',
                        balance: balance,
                      ),
                      _buildContactItem(
                        context,
                        name: 'Lavender',
                        balance: balance,
                      ),
                      _buildContactItem(
                        context,
                        name: 'Grace',
                        balance: balance,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest transaction',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('see all', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot>(
                  stream: txStream,
                  builder: (context, txSnap) {
                    if (!txSnap.hasData || txSnap.data!.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Chưa có giao dịch nào',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      children: txSnap.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title'] ?? 'Transaction';
                        final subtitle = data['subtitle'] ?? '';
                        final amount = (data['amount'] ?? 0.0).toDouble();
                        final type = data['type'] ?? 'withdraw';
                        final ts = data['createdAt'] as Timestamp?;
                        final dateStr = ts != null
                            ? DateFormat('MMM dd, yyyy').format(ts.toDate())
                            : 'Today';
                        final isIncome = type == 'deposit';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      subtitle,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${isIncome ? '+' : '-'}${moneyFormat.format(amount)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isIncome
                                          ? Colors.green
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required String name,
    bool isAdd = false,
    required double balance,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MoneyActionScreen(
              mode: MoneyActionMode.transfer,
              currentBalance: balance,
              recipientName: isAdd ? 'Amazon' : name,
            ),
          ),
        );
      },
      child: Container(
        width: 66,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  isAdd ? const Color(0xFFEDEAFE) : Colors.indigo.shade100,
              child: isAdd
                  ? const Icon(Icons.add, color: Color(0xFF5C4CE6))
                  : Text(
                      name[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C4CE6),
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

enum MoneyActionMode { topUp, withdraw, transfer }

class MoneyActionScreen extends StatefulWidget {
  final MoneyActionMode mode;
  final double currentBalance;
  final String recipientName;

  const MoneyActionScreen({
    super.key,
    required this.mode,
    required this.currentBalance,
    this.recipientName = 'Amazon',
  });

  @override
  State<MoneyActionScreen> createState() => _MoneyActionScreenState();
}

class _MoneyActionScreenState extends State<MoneyActionScreen> {
  String _amountText = '1740.00';
  bool _processing = false;

  String get _screenTitle {
    switch (widget.mode) {
      case MoneyActionMode.topUp:
        return 'Top Up';
      case MoneyActionMode.withdraw:
        return 'Withdraw';
      case MoneyActionMode.transfer:
        return 'Send Money';
    }
  }

  String get _buttonLabel {
    switch (widget.mode) {
      case MoneyActionMode.topUp:
        return 'Top Up Money';
      case MoneyActionMode.withdraw:
        return 'Withdraw Money';
      case MoneyActionMode.transfer:
        return 'Send money';
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'del') {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
        if (_amountText.isEmpty) _amountText = '0';
      } else if (key == '.') {
        if (!_amountText.contains('.')) {
          _amountText += '.';
        }
      } else {
        if (_amountText == '0') {
          _amountText = key;
        } else {
          _amountText += key;
        }
      }
    });
  }

  Future<void> _executeTransaction() async {
    final amount = double.tryParse(_amountText) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền phải lớn hơn 0')),
      );
      return;
    }

    if (widget.mode != MoneyActionMode.topUp &&
        amount > widget.currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số dư ví không đủ')),
      );
      return;
    }

    setState(() => _processing = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final newBalance = widget.mode == MoneyActionMode.topUp
          ? widget.currentBalance + amount
          : widget.currentBalance - amount;

      String title;
      String subtitle;
      String type;

      switch (widget.mode) {
        case MoneyActionMode.topUp:
          title = 'Deposit';
          subtitle = 'Top up to wallet';
          type = 'deposit';
          break;
        case MoneyActionMode.withdraw:
          title = 'Withdraw';
          subtitle = 'Cardless withdraw';
          type = 'withdraw';
          break;
        case MoneyActionMode.transfer:
          title = 'Bank transfer';
          subtitle = 'to ${widget.recipientName}';
          type = 'transfer';
          break;
      }

      final batch = FirebaseFirestore.instance.batch();
      batch.update(userRef, {'balance': newBalance});
      final txRef = userRef.collection('transactions').doc();
      batch.set(txRef, {
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'type': type,
        'createdAt': Timestamp.now(),
      });
      await batch.commit();

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi giao dịch: $e')),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5C4CE6);
    final moneyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          _screenTitle,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        color: primaryPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet balance',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Safe to spend ${moneyFormat.format(widget.currentBalance)}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.sync_alt, color: Colors.grey),
                ],
              ),
            ),
            if (widget.mode == MoneyActionMode.transfer) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.recipientName[0].toLowerCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipientName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'New macbook air m2',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
            const Spacer(),
            Text(
              '\$$_amountText',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The transfer will be complete by ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.8,
              mainAxisSpacing: 8,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '.',
                '0',
                'del',
              ].map((key) {
                return InkWell(
                  onTap: () => _onKeyPress(key),
                  borderRadius: BorderRadius.circular(30),
                  child: Center(
                    child: key == 'del'
                        ? const Icon(Icons.backspace_outlined, size: 22)
                        : Text(
                            key,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _processing ? null : _executeTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _processing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _buttonLabel,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletCardScreen extends StatelessWidget {
  const WalletCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final moneyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final balance = (data['balance'] ?? 0.0).toDouble();
          final name = data['name'] ?? 'Zhippay User';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5C4CE6), Color(0xFF2B227C)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ZHIPPAY CARD',
                              style: TextStyle(
                                  color: Colors.white70, letterSpacing: 1.5)),
                          Icon(Icons.contactless, color: Colors.white),
                        ],
                      ),
                      Text(
                        moneyFormat.format(balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name.toUpperCase(),
                              style: const TextStyle(color: Colors.white)),
                          const Text('**** 4589',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String _selectedRange = '1 Tháng';

  DateTime _getStartDate() {
    final now = DateTime.now();
    switch (_selectedRange) {
      case '1 Quý':
        return DateTime(now.year, now.month - 3, now.day);
      case '1 Năm':
        return DateTime(now.year - 1, now.month, now.day);
      default:
        return DateTime(now.year, now.month - 1, now.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final startDate = _getStartDate();
    final moneyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    const primaryPurple = Color(0xFF5C4CE6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê dòng tiền',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['1 Tháng', '1 Quý', '1 Năm'].map((label) {
                final selected = _selectedRange == label;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  selectedColor: primaryPurple,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedRange = label),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('transactions')
                    .where('createdAt',
                        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  double totalIn = 0;
                  double totalOut = 0;
                  final docs = snapshot.data?.docs ?? [];

                  for (final doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final amt = (data['amount'] ?? 0.0).toDouble();
                    final type = data['type'] ?? '';
                    if (type == 'deposit') {
                      totalIn += amt;
                    } else {
                      totalOut += amt;
                    }
                  }

                  final totalVolume = totalIn + totalOut;
                  final inRatio = totalVolume > 0 ? totalIn / totalVolume : 0.5;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Tiền vào (Nạp)',
                              amount: moneyFormat.format(totalIn),
                              color: Colors.green,
                              icon: Icons.arrow_downward,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Tiền ra (Rút/Chuyển)',
                              amount: moneyFormat.format(totalOut),
                              color: Colors.redAccent,
                              icon: Icons.arrow_upward,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tỷ lệ thu / chi ($_selectedRange)',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: inRatio,
                                minHeight: 16,
                                backgroundColor: Colors.redAccent.withOpacity(0.8),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Thu: ${(inRatio * 100).toStringAsFixed(1)}%'),
                                Text(
                                    'Chi: ${((1 - inRatio) * 100).toStringAsFixed(1)}%'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _updating = false;

  Future<void> _updateProfile() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;
    setState(() => _updating = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.updateDisplayName(newName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': newName});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thành công')),
      );
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    if (_nameController.text.isEmpty) {
      _nameController.text = user.displayName ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF5C4CE6),
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              user.email ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên hiển thị',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updating ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C4CE6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _updating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Lưu thay đổi'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Đăng xuất',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}