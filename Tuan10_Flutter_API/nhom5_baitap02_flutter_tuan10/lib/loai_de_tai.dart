class LoaiDeTai {
  final String maLoai;
  final String tenLoai;

  const LoaiDeTai({
    required this.maLoai,
    required this.tenLoai,
  });

  factory LoaiDeTai.fromJson(Map<String, dynamic> json) {
    return LoaiDeTai(
      maLoai: (json['maLoai'] ?? json['MaLoai'] ?? '').toString(),
      tenLoai: (json['tenLoai'] ?? json['TenLoai'] ?? '').toString(),
    );
  }
}