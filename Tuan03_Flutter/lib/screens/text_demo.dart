import 'package:flutter/material.dart';

class TextDemo extends StatelessWidget {
  const TextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng demo Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sử dụng Text và Image",
            style: TextStyle(
              color: Color.fromARGB(255, 201, 229, 16),
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              
              // Tiêu đề
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "LẬP TRÌNH DI ĐỘNG KHÓA 15!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 235, 19, 19),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Hình ảnh HUIT
              Center(
                child: Image.asset(
                  "assets/images/ratio.jpg",
                  width: 200,
                  height: 160,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Chưa có ảnh",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Chúc các bạn đạt kết quả tốt
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Text(
                  "Chúc các bạn đạt kết quả tốt",
                  style: TextStyle(
                    color: Color.fromARGB(255, 169, 13, 248),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Giảng viên
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  "Giảng viên: Vũ Văn Vinh",
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 63, 244),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Số tiết
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  "Số tiết: 75 tiết",
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 63, 244),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}