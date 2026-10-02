class PhongTro {
  String maSoPhong;
  int soNguoiO;
  double soDien;
  double soNuoc;

  PhongTro({
    required this.maSoPhong,
    required this.soNguoiO,
    required this.soDien,
    required this.soNuoc,
  });

  double tinhTienPhong() {
    return 0;
  }

  @override
  String toString() {
    return 'Mã phòng: $maSoPhong | Số người: $soNguoiO | Điện: $soDien kWh | Nước: $soNuoc m³';
  }
}


class PhongLoaiA extends PhongTro {
  int soNguoiThan;

  PhongLoaiA({
    required String maSoPhong,
    required int soNguoiO,
    required double soDien,
    required double soNuoc,
    required this.soNguoiThan,
  }) : super(
          maSoPhong: maSoPhong,
          soNguoiO: soNguoiO,
          soDien: soDien,
          soNuoc: soNuoc,
        );

  @override
  double tinhTienPhong() {
    return 1400 + 2 * soDien + 8 * soNuoc + 50 * soNguoiThan;
  }

  @override
  String toString() {
    return '${super.toString()} | Số người thân: $soNguoiThan | Loại: A | Tiền phòng: ${tinhTienPhong()}k';
  }
}


class PhongLoaiB extends PhongTro {
  double giatUi;
  int soMay;

  PhongLoaiB({
    required String maSoPhong,
    required int soNguoiO,
    required double soDien,
    required double soNuoc,
    required this.giatUi,
    required this.soMay,
  }) : super(
          maSoPhong: maSoPhong,
          soNguoiO: soNguoiO,
          soDien: soDien,
          soNuoc: soNuoc,
        );

  @override
  double tinhTienPhong() {
    return 2000 + 2 * soDien + 8 * soNuoc + giatUi * 5 + soMay * 10;
  }

  @override
  String toString() {
    return '${super.toString()} | Giặt ủi: ${giatUi}kg | Số máy nét: $soMay | Loại: B | Tiền phòng: ${tinhTienPhong()}k';
  }
}