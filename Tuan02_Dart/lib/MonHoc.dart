// Lớp cơ sở Môn Học
abstract class MonHoc {
  String maMon;
  String tenMon;
  int soTinChi;

  MonHoc({
    required this.maMon,
    required this.tenMon,
    required this.soTinChi,
  });

  // Tính Điểm Trung Bình (DTB)
  double tinhDTB();

  // Quy đổi điểm hệ 4 (Điểm chữ)
  String quyDoiDiemChu() {
    double dtb = tinhDTB();
    if (dtb >= 8.5) return 'A';
    if (dtb >= 7.0) return 'B';
    if (dtb >= 5.5) return 'C';
    if (dtb >= 4.0) return 'D';
    return 'F';
  }

  @override
  String toString() {
    return 'Mã: $maMon | Tên: $tenMon | STC: $soTinChi | ĐTB: ${tinhDTB().toStringAsFixed(2)} | Điểm chữ: ${quyDoiDiemChu()}';
  }
}

// Môn Lý Thuyết
class MonLyThuyet extends MonHoc {
  double diemTieuLuan;
  double diemCuoiKy;

  MonLyThuyet({
    required String maMon,
    required String tenMon,
    required int soTinChi,
    required this.diemTieuLuan,
    required this.diemCuoiKy,
  }) : super(maMon: maMon, tenMon: tenMon, soTinChi: soTinChi);

  @override
  double tinhDTB() => diemTieuLuan * 0.3 + diemCuoiKy * 0.7;
}

// Môn Thực Hành
class MonThucHanh extends MonHoc {
  double diemKT1;
  double diemKT2;
  double diemKT3;

  MonThucHanh({
    required String maMon,
    required String tenMon,
    required int soTinChi,
    required this.diemKT1,
    required this.diemKT2,
    required this.diemKT3,
  }) : super(maMon: maMon, tenMon: tenMon, soTinChi: soTinChi);

  @override
  double tinhDTB() => (diemKT1 + diemKT2 + diemKT3) / 3;
}

// Môn Đồ Án
class MonDoAn extends MonHoc {
  double diemGVHD;
  double diemGVPB;

  MonDoAn({
    required String maMon,
    required String tenMon,
    required int soTinChi,
    required this.diemGVHD,
    required this.diemGVPB,
  }) : super(maMon: maMon, tenMon: tenMon, soTinChi: soTinChi);

  @override
  double tinhDTB() => (diemGVHD + diemGVPB) / 2;
}