import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeFromCart(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.cartItems.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  void _checkout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thanh toán'),
        content: const Text('Bạn đã thanh toán xong giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.cartItems.clear();
              });
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Bạn chưa bỏ sản phẩm nào vào giỏ hàng!!!',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Giỏ hàng của bạn', style: TextStyle(color: Colors.grey)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (ctx, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('${item.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeFromCart(index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text('Thanh toán'),
                  ),
                ),
              ],
            ),
    );
  }
}