import 'dart:io';

abstract class HoaDon {
  String _maKH = 'KH0000';
  String _tenKH = '';
  int _soLuong = 0;
  double _giaBan = 0;

  // Constructors
  HoaDon();

  HoaDon.fullPara(String maKH, String tenKH, int soLuong, double giaBan) {
    this.maKH = maKH;
    this.tenKH = tenKH;
    this.soLuong = soLuong;
    this.giaBan = giaBan;
  }

  // Getters & Setters có Validate
  String get maKH => _maKH;
  set maKH(String value) {
    RegExp regex = RegExp(r'^KH\d{4}$');
    if (regex.hasMatch(value)) {
      _maKH = value;
    } else {
      print('Lỗi: Mã KH phải dạng KHxxxx (vd: KH0002). Đã gán mặc định KH0000.');
      _maKH = 'KH0000';
    }
  }

  String get tenKH => _tenKH;
  set tenKH(String value) {
    if (value.trim().isNotEmpty) {
      _tenKH = value;
    } else {
      print('Lỗi: Tên KH không được để trống.');
      _tenKH = 'Khách Không Tên';
    }
  }

  int get soLuong => _soLuong;
  set soLuong(int value) {
    _soLuong = value > 0 ? value : 1;
  }

  double get giaBan => _giaBan;
  set giaBan(double value) {
    _giaBan = value > 0 ? value : 0;
  }

  // Phương thức tính toán
  double tinhThueVAT() => _soLuong * _giaBan * 0.10;
  double tinhChietKhau();
  double tinhTroGia() => 0; // Mặc định đại lý không có trợ giá

  double tinhThanhTien() {
    return (_soLuong * _giaBan) - tinhChietKhau() + tinhThueVAT() - tinhTroGia();
  }

  // Nhập xuất thông tin
  void nhapThongTin() {
    stdout.write('Nhập mã KH (KHxxxx): ');
    maKH = stdin.readLineSync() ?? '';
    stdout.write('Nhập tên KH: ');
    tenKH = stdin.readLineSync() ?? '';
    stdout.write('Nhập số lượng: ');
    soLuong = int.tryParse(stdin.readLineSync() ?? '') ?? 1;
    stdout.write('Nhập giá bán: ');
    giaBan = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  }

  @override
  String toString() {
    return 'Mã KH: $_maKH | Tên: $_tenKH | SL: $_soLuong | Giá: $_giaBan | VAT: ${tinhThueVAT()} | CK: ${tinhChietKhau()} | Trợ giá: ${tinhTroGia()} | Thành tiền: ${tinhThanhTien()}';
  }
}

// 1. Khách hàng cá nhân
class KhachHangCaNhan extends HoaDon {
  double khoangCach = 0;

  KhachHangCaNhan() : super();
  KhachHangCaNhan.fullPara(String maKH, String tenKH, int soLuong, double giaBan, this.khoangCach)
      : super.fullPara(maKH, tenKH, soLuong, giaBan);

  @override
  double tinhChietKhau() {
    double ck = 0;
    if (soLuong >= 3) {
      ck += 0.05 * giaBan * soLuong;
    }
    if (khoangCach < 10) {
      ck += 50000 * soLuong;
    }
    return ck;
  }

  @override
  double tinhTroGia() {
    double tg = 0.02 * giaBan * soLuong;
    if (soLuong > 2) {
      tg += 100000;
    }
    return tg;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhập khoảng cách giao hàng (km): ');
    khoangCach = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  }
}

// 2. Đại lý cấp 1
class DaiLyCap1 extends HoaDon {
  int namHopTac = 0;

  DaiLyCap1() : super();
  DaiLyCap1.fullPara(String maKH, String tenKH, int soLuong, double giaBan, this.namHopTac)
      : super.fullPara(maKH, tenKH, soLuong, giaBan);

  @override
  double tinhChietKhau() {
    double phanTram = 0.30;
    if (namHopTac > 5) {
      int namVuot = namHopTac - 5;
      phanTram += namVuot * 0.01;
      if (phanTram > 0.35) phanTram = 0.35;
    }
    return phanTram * giaBan * soLuong;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhập số năm hợp tác: ');
    namHopTac = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  }
}

// 3. Khách hàng Công ty
class KhachHangCongTy extends HoaDon {
  int soLuongNhanVien = 0;

  KhachHangCongTy() : super();
  KhachHangCongTy.fullPara(String maKH, String tenKH, int soLuong, double giaBan, this.soLuongNhanVien)
      : super.fullPara(maKH, tenKH, soLuong, giaBan);

  @override
  double tinhChietKhau() {
    double phanTram = 0;
    if (soLuongNhanVien > 5000) {
      phanTram = 0.07;
    } else if (soLuongNhanVien > 1000) {
      phanTram = 0.05;
    }
    return phanTram * giaBan * soLuong;
  }

  @override
  double tinhTroGia() {
    return 120000.0 * soLuong;
  }

  @override
  void nhapThongTin() {
    super.nhapThongTin();
    stdout.write('Nhập số lượng nhân viên: ');
    soLuongNhanVien = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  }
}