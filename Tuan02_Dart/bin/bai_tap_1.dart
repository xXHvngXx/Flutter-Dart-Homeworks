import 'dart:io';
import '../lib/PhongTro.dart';

Future<List<PhongTro>> docFilePhongThue(String filePath) async {
  List<PhongTro> dsPhong = [];
  try {
    List<String> lines = await File(filePath).readAsLines();
    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split('#');

      String maPhong = parts[0].trim();
      int soNguoi = int.parse(parts[1].trim());
      double soDien = double.parse(parts[2].trim());
      double soNuoc = double.parse(parts[3].trim());

      if (maPhong.startsWith('A')) {
        int soNguoiThan = int.parse(parts[4].trim());
        dsPhong.add(PhongLoaiA(
          maSoPhong: maPhong,
          soNguoiO: soNguoi,
          soDien: soDien,
          soNuoc: soNuoc,
          soNguoiThan: soNguoiThan,
        ));
      } else if (maPhong.startsWith('B')) {
        double giatUi = double.parse(parts[4].trim());
        int soMay = int.parse(parts[5].trim());
        dsPhong.add(PhongLoaiB(
          maSoPhong: maPhong,
          soNguoiO: soNguoi,
          soDien: soDien,
          soNuoc: soNuoc,
          giatUi: giatUi,
          soMay: soMay,
        ));
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
  }
  return dsPhong;
}

void main() async {
  String filePath = 'lib/phongthue.txt';
  List<PhongTro> dsPhong = await docFilePhongThue(filePath);

  print('=================== DANH SÁCH TẤT CẢ PHÒNG THUÊ ===================');
  for (var p in dsPhong) {
    print(p);
  }

  print('\n=================== PHÒNG CÓ SỐ NGƯỜI THUÊ > 2 ===================');
  var phongNguoiLonHon2 = dsPhong.where((p) => p.soNguoiO > 2);
  for (var p in phongNguoiLonHon2) {
    print(p);
  }

  double tongTien = dsPhong.fold(0, (sum, p) => sum + p.tinhTienPhong());
  print('\n-------------------------------------------------------------------');
  print('TỔNG TIỀN PHÒNG THU ĐƯỢC: ${tongTien}k VNĐ');
  print('-------------------------------------------------------------------');

  dsPhong.sort((a, b) => b.soDien.compareTo(a.soDien));
  print('\n================ DANH SÁCH GIẢM DẦN THEO SỐ ĐIỆN ================');
  for (var p in dsPhong) {
    print(p);
  }

  print('\n==================== DANH SÁCH PHÒNG LOẠI A ====================');
  var phongLoaiA = dsPhong.whereType<PhongLoaiA>();
  for (var p in phongLoaiA) {
    print(p);
  }
}