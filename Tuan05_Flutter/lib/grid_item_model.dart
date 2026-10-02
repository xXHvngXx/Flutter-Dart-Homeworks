import 'package:flutter/material.dart';

class GirdItem {
  final String title;
  final IconData icon;

  GirdItem({required this.title, required this.icon});
}

class MyGirdView02 extends StatefulWidget {
  const MyGirdView02({super.key});

  @override
  State<MyGirdView02> createState() => _MyGirdView02State();
}

class _MyGirdView02State extends State<MyGirdView02> {
  final List<GirdItem> lst = [
    GirdItem(title: 'Login', icon: Icons.login),
    GirdItem(title: 'Search', icon: Icons.search),
    GirdItem(title: 'Profile', icon: Icons.person),
    GirdItem(title: 'Setting', icon: Icons.settings),
    GirdItem(title: 'Cart', icon: Icons.shopping_cart),
    GirdItem(title: 'Payment', icon: Icons.payment),
    GirdItem(title: 'Task', icon: Icons.add_task),
    GirdItem(title: 'Alert', icon: Icons.add_alert),
    GirdItem(title: 'Bank', icon: Icons.account_balance),
    GirdItem(title: 'Wallet', icon: Icons.account_balance_wallet),
    GirdItem(title: 'Email', icon: Icons.mail),
    GirdItem(title: 'More', icon: Icons.arrow_circle_right_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 205, 18),
        title: const Text('GridView demo 02'),
      ),
      body: GridView.builder(
        itemCount: lst.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blue,
            child: InkWell(
              onTap: () {
                // Xử lý sự kiện khi bấm vào từng ô
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    lst[index].icon, 
                    size: 32, 
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lst[index].title,
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}