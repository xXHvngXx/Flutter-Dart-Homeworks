import 'dart:io';
import '../lib/HoaDon.dart';
import '../lib/QuanLyHoaDon.dart';

void main() {
  QuanLyHoaDon ql = QuanLyHoaDon();

  // Tạo sẵn dữ liệu mẫu 
  ql.dsHoaDon.addAll([
    KhachHangCaNhan.fullPara('KH0001', 'Nguyễn Văn A', 4, 5000000, 8),
    DaiLyCap1.fullPara('KH0002', 'Đại lý Kim Long', 10, 4800000, 7),
    KhachHangCongTy.fullPara('KH0003', 'Công ty FPT', 10, 5000000, 6000),
    KhachHangCaNhan.fullPara('KH0004', 'Trần Thị B', 2, 6000000, 15),
  ]);

  print('=== CHƯƠNG TRÌNH QUẢN LÝ HÓA ĐƠN BÁN MÁY LẠNH ===');
  ql.xuatDanhSach();

  print('\n---> Tổng thành tiền tất cả hóa đơn: ${ql.tinhTongThanhTien()} VNĐ');
  print('---> Tổng tiền công ty đã trợ giá: ${ql.tinhTongTroGia()} VNĐ');
  print('---> Tổng chiết khấu cho KH Công ty: ${ql.tinhTongChietKhauCongTy()} VNĐ');

  ql.timKhachHangMuaNhieuNhat();

  print('\n================ SẮP XẾP DANH SÁCH HÓA ĐƠN ================');
  ql.sapXepDanhSach();
  ql.xuatDanhSach();

  stdout.write('\nNhập mã khách hàng cần tìm (vd: KH0002): ');
  String? maSearch = stdin.readLineSync();
  if (maSearch != null && maSearch.isNotEmpty) {
    ql.timKiemTheoMa(maSearch);
  }
}