import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'intro_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // Danh sách giỏ hàng dùng chung
  final List<Product> _cart = [];

  // Dữ liệu sản phẩm mẫu
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Điện thoại 01',
      description: 'đại thoại mới của hãng Samsung với công nghệ hiện đại',
      price: 1200.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      name: 'Điện thoại 02',
      description: 'điện thoại mới của hãng Apple với thiết kế cao cấp',
      price: 2000.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  // Xử lý thêm vào giỏ hàng
  void _addToCart(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn vừa thêm sản phẩm vào Giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cart.add(product);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cửa hàng điện thoại'),
        backgroundColor: const Color(0xFFFFC107),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: _cart),
                ),
              );
            },
          ),
        ],
      ),
      // Drawer điều hướng
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school, size: 35, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  Text('Vũ Văn Vinh', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('vinhvv@huit.edu.vn', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.blue),
              title: const Text('Cửa hàng'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.blue),
              title: const Text('Giỏ hàng'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cartItems: _cart),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.blue),
              title: const Text('Thoát'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const IntroScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Chọn sản phẩm bạn muốn sử dụng', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final p = _products[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.black12,
                              child: const Center(child: Icon(Icons.phone_android, size: 60)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(p.description, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${p.price}'),
                              IconButton(
                                icon: const Icon(Icons.add_box, color: Colors.teal),
                                onPressed: () => _addToCart(p),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text('Sản phẩm được lựa chọn nhiều nhất', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}