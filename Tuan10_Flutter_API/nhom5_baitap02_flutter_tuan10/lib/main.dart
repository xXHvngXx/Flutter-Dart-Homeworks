import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loai_de_tai.dart';
import 'chuyen_nganh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý đồ án',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const TrangChu(),
    );
  }
}

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  // Đảm bảo thay địa chỉ IP và Port 5129 
  final String urlLoaiDeTai = 'http://172.17.101.37:5129/api/LoaiDeTai';
  final String urlChuyenNganh = 'http://172.17.101.37:5129/api/ChuyenNganh';

  List<LoaiDeTai> danhSachLoai = [];
  List<ChuyenNganh> danhSachChuyenNganh = [];

  String? maLoaiDangChon;
  bool dangTai = true;
  String? loi;

  @override
  void initState() {
    super.initState();
    taiDuLieu();
  }

  Future<void> taiDuLieu() async {
    setState(() {
      dangTai = true;
      loi = null;
    });

    try {
      final ketQua = await Future.wait([
        http.get(Uri.parse(urlLoaiDeTai)),
        http.get(Uri.parse(urlChuyenNganh)),
      ]);

      if (ketQua[0].statusCode != 200) {
        throw Exception('Không tải được loại đề tài. Mã lỗi: ${ketQua[0].statusCode}');
      }

      if (ketQua[1].statusCode != 200) {
        throw Exception('Không tải được chuyên ngành. Mã lỗi: ${ketQua[1].statusCode}');
      }

      final List<dynamic> jsonLoai = jsonDecode(ketQua[0].body) as List<dynamic>;
      final List<dynamic> jsonChuyenNganh = jsonDecode(ketQua[1].body) as List<dynamic>;

      final loaiMoi = jsonLoai
          .map((item) => LoaiDeTai.fromJson(item as Map<String, dynamic>))
          .toList();

      final chuyenNganhMoi = jsonChuyenNganh
          .map((item) => ChuyenNganh.fromJson(item as Map<String, dynamic>))
          .toList();

      if (!mounted) return;

      setState(() {
        danhSachLoai = loaiMoi;
        danhSachChuyenNganh = chuyenNganhMoi;

        if (danhSachLoai.isNotEmpty) {
          maLoaiDangChon = danhSachLoai.first.maLoai;
        }

        dangTai = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        dangTai = false;
        loi = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ListView Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: taiDuLieu,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại dữ liệu',
          ),
        ],
      ),
      body: dangTai
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : loi != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Lỗi tải dữ liệu:\n$loi',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: taiDuLieu,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: taiDuLieu,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      const Text(
                        'Loại đề tài',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (danhSachLoai.isEmpty)
                        const Text('Không có loại đề tài.')
                      else
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: danhSachLoai.map((item) {
                            final bool dangChon = maLoaiDangChon == item.maLoai;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  maLoaiDangChon = item.maLoai;
                                });
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 34,
                                    backgroundColor: dangChon
                                        ? Colors.deepOrange
                                        : Colors.blue,
                                    child: Text(
                                      item.maLoai,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 90,
                                    child: Text(
                                      item.tenLoai,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        'Danh sách chuyên ngành',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (danhSachChuyenNganh.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Không có chuyên ngành.'),
                        )
                      else
                        ...danhSachChuyenNganh.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.school),
                              ),
                              title: Text(item.tenCN),
                              subtitle: Text(
                                '${item.maCN}\n${item.moTa}',
                              ),
                              isThreeLine: true,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Loại đề tài: '
                                      '${maLoaiDangChon ?? "Chưa chọn"}\n'
                                      'Chuyên ngành: ${item.tenCN}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}