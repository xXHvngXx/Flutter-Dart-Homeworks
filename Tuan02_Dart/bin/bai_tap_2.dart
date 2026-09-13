import 'dart:io';
import '../lib/MonHoc.dart';

// Hàm đọc file monhoc.txt
Future<List<MonHoc>> docFileMonHoc(String filePath) async {
  List<MonHoc> ds = [];
  try {
    List<String> lines = await File(filePath).readAsLines();
    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> p = line.split('#');
      String loai = p[0].trim();
      String ma = p[1].trim();
      String ten = p[2].trim();
      int stc = int.parse(p[3].trim());

      if (loai == 'LT') {
        ds.add(MonLyThuyet(
          maMon: ma,
          tenMon: ten,
          soTinChi: stc,
          diemTieuLuan: double.parse(p[4].trim()),
          diemCuoiKy: double.parse(p[5].trim()),
        ));
      } else if (loai == 'TH') {
        ds.add(MonThucHanh(
          maMon: ma,
          tenMon: ten,
          soTinChi: stc,
          diemKT1: double.parse(p[4].trim()),
          diemKT2: double.parse(p[5].trim()),
          diemKT3: double.parse(p[6].trim()),
        ));
      } else if (loai == 'DA') {
        ds.add(MonDoAn(
          maMon: ma,
          tenMon: ten,
          soTinChi: stc,
          diemGVHD: double.parse(p[4].trim()),
          diemGVPB: double.parse(p[5].trim()),
        ));
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
  }
  return ds;
}

// Kiểm tra danh sách có sắp xếp tăng dần theo tên môn học không
bool kiemTraTangDanTheoTen(List<MonHoc> ds) {
  for (int i = 0; i < ds.length - 1; i++) {
    if (ds[i].tenMon.compareTo(ds[i + 1].tenMon) > 0) {
      return false;
    }
  }
  return true;
}

void main() async {
  // 1. Đọc nội dung file monhoc.txt vào danh sách
  List<MonHoc> dsMonHoc = await docFileMonHoc('lib/monhoc.txt');

  // 2. Xuất danh sách môn học ra màn hình
  print('================ DANH SÁCH MÔN HỌC ĐỌC TỪ FILE ================');
  dsMonHoc.forEach(print);

  // 3. Kiểm tra danh sách có sắp xếp tăng dần theo tên môn học hay không
  bool isSorted = kiemTraTangDanTheoTen(dsMonHoc);
  print('\n---> Danh sách ${isSorted ? "ĐÃ" : "CHƯA"} được sắp xếp tăng dần theo tên môn học.');

  // 4. Sắp xếp danh sách môn học tăng dần theo số tín chỉ
  dsMonHoc.sort((a, b) => a.soTinChi.compareTo(b.soTinChi));
  print('\n================ DANH SÁCH TĂNG DẦN THEO TÍN CHỈ ================');
  dsMonHoc.forEach(print);

  // 5. Cho biết các môn học có số tín chỉ cao nhất
  int maxSTC = dsMonHoc.map((m) => m.soTinChi).reduce((a, b) => a > b ? a : b);
  print('\n================ MÔN HỌC CÓ SỐ TÍN CHỈ CAO NHẤT ($maxSTC STC) ================');
  dsMonHoc.where((m) => m.soTinChi == maxSTC).forEach(print);

  // 6. Tính số tín chỉ trung bình của các môn học
  double tongSTC = dsMonHoc.fold(0, (sum, m) => sum + m.soTinChi);
  double stcTrungBinh = tongSTC / dsMonHoc.length;
  print('\n---> Số tín chỉ trung bình của các môn học: ${stcTrungBinh.toStringAsFixed(2)}');

  // 7. Nhập tên môn học bất kỳ từ bàn phím để tìm kiếm / thêm mới
  stdout.write('\nNhập tên môn học cần tìm: ');
  String? tenTimKiem = stdin.readLineSync();

  if (tenTimKiem != null && tenTimKiem.isNotEmpty) {
    var timThay = dsMonHoc.where(
      (m) => m.tenMon.toLowerCase() == tenTimKiem.trim().toLowerCase(),
    );

    if (timThay.isNotEmpty) {
      print('\n[KẾT QUẢ] Tìm thấy thông tin môn học:');
      timThay.forEach(print);
    } else {
      print('\n[KẾT QUẢ] Không tìm thấy "$tenTimKiem". Tiến hành thêm mới môn học vào cuối danh sách...');
      
      // Thêm mẫu 1 môn Lý thuyết mới
      MonHoc monMoi = MonLyThuyet(
        maMon: 'MH_NEW',
        tenMon: tenTimKiem.trim(),
        soTinChi: 3,
        diemTieuLuan: 8.0,
        diemCuoiKy: 8.0,
      );
      dsMonHoc.add(monMoi);

      print('\n================ DANH SÁCH CẬP NHẬT SAU KHregions THÊM ================');
      dsMonHoc.forEach(print);
    }
  }
}