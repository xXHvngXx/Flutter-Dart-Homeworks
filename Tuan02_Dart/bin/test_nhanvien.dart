import 'package:minhhung_dart_application_tuan02/NhanVien.dart';
import 'package:minhhung_dart_application_tuan02/CanBo.dart';

void main() {
  NhanVien nv = NhanVien.fullPara("NV001", "Nguyễn Trần Tuấn", 2.34, "Tổ chức", 23);
  
  CanBo cb = CanBo.fullPara(
    'NV002', 'Trần Văn Bình', 2.34, "Tổ chức", 26, "Trưởng phòng", 2.0
  );
  
  NhanVien nv3 = NhanVien.fullPara("NV003", "Nguyễn Nam", 2.34, "Nhân sự", 27);


  List<NhanVien> lstNhanVien = [];
  lstNhanVien.add(nv);
  lstNhanVien.add(cb);
  lstNhanVien.add(nv3);

  print("Danh sách nhân viên và cán bộ: ");
  for (NhanVien x in lstNhanVien) {
    print(x);
  }

  
  List<NhanVien> lstLoaiA = lstNhanVien.where((a) => a.xepLoai() == "A").toList();
  print('\nDanh sách nhân viên và cán bộ xếp loại A:');
  for (NhanVien x in lstLoaiA) {
    print(x);
  }


  double tongLuong = lstNhanVien.fold(0, (sum, nv) => sum + nv.tinhLuong());
  print("\nTổng lương của nhân viên và cán bộ: $tongLuong");

  
  lstNhanVien.sort((x, y) => x.tinhLuong().compareTo(y.tinhLuong()));
  print("\nDanh sách sau khi sắp xếp tăng dần theo lương là:");
  for (NhanVien x in lstNhanVien) {
    print(x);
  }
}