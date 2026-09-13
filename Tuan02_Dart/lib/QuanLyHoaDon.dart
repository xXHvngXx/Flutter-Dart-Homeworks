import 'dart:io';
import 'HoaDon.dart';

class QuanLyHoaDon {
  List<HoaDon> dsHoaDon = [];

  // Nhập danh sách hóa đơn
  void nhapDanhSach() {
    stdout.write('Nhập số lượng hóa đơn cần thêm: ');
    int n = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    for (int i = 0; i < n; i++) {
      print('\n--- Nhập hóa đơn thứ ${i + 1} ---');
      print('Chọnt loại khách hàng: 1. Cá nhân | 2. Đại lý Cấp 1 | 3. Công ty');
      stdout.write('Lựa chọn (1-3): ');
      int chon = int.tryParse(stdin.readLineSync() ?? '') ?? 1;

      HoaDon hd;
      if (chon == 2) {
        hd = DaiLyCap1();
      } else if (chon == 3) {
        hd = KhachHangCongTy();
      } else {
        hd = KhachHangCaNhan();
      }
      hd.nhapThongTin();
      dsHoaDon.add(hd);
    }
  }

  // Xuất danh sách hóa đơn
  void xuatDanhSach() {
    print('\n================ DANH SÁCH HÓA ĐƠN ================');
    if (dsHoaDon.isEmpty) {
      print('Danh sách trống!');
      return;
    }
    dsHoaDon.forEach(print);
  }

  // Tổng thành tiền
  double tinhTongThanhTien() {
    return dsHoaDon.fold(0, (sum, hd) => sum + hd.tinhThanhTien());
  }

  // Tổng tiền trợ giá
  double tinhTongTroGia() {
    return dsHoaDon.fold(0, (sum, hd) => sum + hd.tinhTroGia());
  }

  // Khách hàng có số lượng mua nhiều nhất
  void timKhachHangMuaNhieuNhat() {
    if (dsHoaDon.isEmpty) return;
    int maxSL = dsHoaDon.map((e) => e.soLuong).reduce((a, b) => a > b ? a : b);
    print('\n================ KHÁCH HÀNG MUA NHIỀU NHẤT ($maxSL SP) ================');
    dsHoaDon.where((e) => e.soLuong == maxSL).forEach(print);
  }

  // Tổng chiết khấu dành cho KH Công ty
  double tinhTongChietKhauCongTy() {
    return dsHoaDon
        .whereType<KhachHangCongTy>()
        .fold(0, (sum, hd) => sum + hd.tinhChietKhau());
  }

  // Sắp xếp: Tăng dần số lượng, nếu bằng nhau thì giảm dần thành tiền
  void sapXepDanhSach() {
    dsHoaDon.sort((a, b) {
      int cmpSL = a.soLuong.compareTo(b.soLuong);
      if (cmpSL != 0) return cmpSL;
      return b.tinhThanhTien().compareTo(a.tinhThanhTien());
    });
  }

  // Tìm hóa đơn theo mã khách hàng X
  void timKiemTheoMa(String maX) {
    var tim = dsHoaDon.where((hd) => hd.maKH.toUpperCase() == maX.trim().toUpperCase());
    if (tim.isNotEmpty) {
      print('\n================ CÁC HÓA ĐƠN CỦA MÃ $maX ================');
      tim.forEach(print);
    } else {
      print('\n[THÔNG BÁO] Khách hàng lạ');
    }
  }
}