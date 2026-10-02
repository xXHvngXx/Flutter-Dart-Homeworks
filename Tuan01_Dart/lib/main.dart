import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('\n==================== MENU BÀI TẬP DART ====================');
    print('1. [TỰ LÀM] Bài 1: Tính tiền mua kem');
    print('2. [TỰ LÀM] Bài 2: Xử lý số nguyên dương > 10');
    print('3. [TỰ LÀM] Bài 3: Thao tác danh sách số nguyên');
    print('4. [VỀ NHÀ] Bài 1: Danh sách số ngẫu nhiên (5 - 100)');
    print('5. [VỀ NHÀ] Bài 2: Xử lý chuỗi ký tự');
    print('0. Thoát chương trình');
    print('-----------------------------------------------------------');
    stdout.write('--> Nhập lựa chọn của bạn (0-5): ');

    String? chon = stdin.readLineSync();
    print('\n===========================================================');

    switch (chon) {
      case '1':
        baiTapTuLam1();
        break;
      case '2':
        baiTapTuLam2();
        break;
      case '3':
        baiTapTuLam3();
        break;
      case '4':
        baiTapVeNha1();
        break;
      case '5':
        baiTapVeNha2();
        break;
      case '0':
        print('Đã thoát chương trình. Tạm biệt!');
        return;
      default:
        print('Lựa chọn không hợp lệ! Vui lòng chọn từ 0 đến 5.');
    }
  }
}

// =========================================================================
// I. BÀI TẬP TỰ LÀM
// =========================================================================

// Bài 1: Tính tiền mua kem
void baiTapTuLam1() {
  print('--- I. BÀI TẬP TỰ LÀM - BÀI 1: TÍNH TIỀN KEM ---');
  stdout.write('Nhập số lượng que kem cần mua (>0): ');
  int n = int.parse(stdin.readLineSync()!);

  if (n <= 0) {
    print('Số lượng que kem phải lớn hơn 0!');
    return;
  }

  stdout.write('Nhập giá tiền cho 1 que kem: ');
  double gia = double.parse(stdin.readLineSync()!);

  double tongTien = n * gia;
  double giamGia = 0;

  if (n > 10) {
    giamGia = 0.10; // Giảm 10%
  } else if (n >= 5) {
    giamGia = 0.05; // Giảm 5%
  }

  double thanhTien = tongTien * (1 - giamGia);

  print('Tổng tiền ban đầu: $tongTien');
  print('Mức giảm giá: ${giamGia * 100}%');
  print('Số tiền phải trả: $thanhTien');
}

// Bài 2: Xử lý số nguyên dương > 10
void baiTapTuLam2() {
  print('--- I. BÀI TẬP TỰ LÀM - BÀI 2: XỬ LÝ SỐ NGUYÊN > 10 ---');
  stdout.write('Nhập vào một số nguyên dương > 10: ');
  String input = stdin.readLineSync()!;
  int? n = int.tryParse(input);

  if (n == null || n <= 10) {
    print('Số nhập vào không hợp lệ hoặc không lớn hơn 10!');
    return;
  }

  // a. Cho biết số nguyên nhập vào có bao nhiêu chữ số
  print('a. Số $n có ${input.length} chữ số.');

  // b. Tính tổng các chữ số & c. Kiểm tra chữ số lẻ
  int tong = 0;
  bool coChuSoLe = false;

  for (int i = 0; i < input.length; i++) {
    int chuSo = int.parse(input[i]);
    tong += chuSo;

    if (chuSo % 2 != 0) {
      coChuSoLe = true;
    }
  }

  print('b. Tổng các chữ số trong $n là: $tong');
  print('c. Số $n ${coChuSoLe ? "CÓ" : "KHÔNG CÓ"} chứa chữ số lẻ.');
}

// Hàm bổ trợ kiểm tra số nguyên tố cho Bài 3
bool laSoNguyenTo(int n) {
  if (n < 2) return false;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

// Bài 3: Thao tác danh sách số nguyên
void baiTapTuLam3() {
  print('--- I. BÀI TẬP TỰ LÀM - BÀI 3: DANH SÁCH SỐ NGUYÊN ---');
  stdout.write('Nhập số lượng phần tử của danh sách: ');
  int n = int.parse(stdin.readLineSync()!);

  List<int> ds = [];
  for (int i = 0; i < n; i++) {
    stdout.write('Nhập phần tử thứ ${i + 1}: ');
    ds.add(int.parse(stdin.readLineSync()!));
  }

  // a. Xuất danh sách vừa nhập
  print('\na. Danh sách vừa nhập: $ds');

  // b. Tính tổng các phần tử
  int tong = 0;
  for (int x in ds) {
    tong += x;
  }
  print('b. Tổng các phần tử trong danh sách: $tong');

  // c. Xuất các số nguyên tố có trong danh sách
  List<int> dsSNT = [];
  for (int x in ds) {
    if (laSoNguyenTo(x)) {
      dsSNT.add(x);
    }
  }
  print('c. Các số nguyên tố có trong danh sách: $dsSNT');

  // d. Tìm giá trị và thêm vào đầu/xuất vị trí
  stdout.write('d. Nhập vào một giá trị bất kỳ: ');
  int val = int.parse(stdin.readLineSync()!);

  int viTri = ds.indexOf(val);
  if (viTri != -1) {
    print('-> Giá trị $val CÓ trong danh sách tại vị trí index: $viTri');
  } else {
    ds.insert(0, val);
    print('-> Giá trị $val KHÔNG CÓ trong danh sách. Đã thêm vào đầu danh sách.');
    print('   Danh sách mới: $ds');
  }
}

// =========================================================================
// II. BÀI TẬP VỀ NHÀ
// =========================================================================

// Bài 1: Danh sách số ngẫu nhiên trong phạm vi từ 5 đến 100
void baiTapVeNha1() {
  print('--- II. BÀI TẬP VỀ NHÀ - BÀI 1: DANH SÁCH NGẪU NHIÊN ---');
  Random rand = Random();
  List<int> ds = [];


  for (int i = 0; i < 10; i++) {
    ds.add(5 + rand.nextInt(96));
  }

  // a. Xuất các phần tử ra màn hình
  print('a. Danh sách ngẫu nhiên tạo ra: $ds');

  // b. Tính trung bình cộng các số lẻ
  int tongLe = 0;
  int demSoLe = 0;
  for (int x in ds) {
    if (x % 2 != 0) {
      tongLe += x;
      demSoLe++;
    }
  }
  if (demSoLe == 0) {
    print('b. Thông báo: Danh sách không có số lẻ.');
  } else {
    print('b. Trung bình cộng các số lẻ: ${tongLe / demSoLe}');
  }

  // c. Kiểm tra danh sách đối xứng
  bool doiXung = true;
  for (int i = 0; i < ds.length ~/ 2; i++) {
    if (ds[i] != ds[ds.length - 1 - i]) {
      doiXung = false;
      break;
    }
  }
  print('c. Danh sách có đối xứng hay không: ${doiXung ? "CÓ" : "KHÔNG"}');

  // d. Kiểm tra danh sách được sắp xếp tăng dần hay không
  bool tangDan = true;
  for (int i = 0; i < ds.length - 1; i++) {
    if (ds[i] > ds[i + 1]) {
      tangDan = false;
      break;
    }
  }
  print('d. Danh sách có được sắp xếp tăng dần: ${tangDan ? "CÓ" : "KHÔNG"}');

  // e. Tìm phần tử lớn nhất
  int maxVal = ds[0];
  for (int x in ds) {
    if (x > maxVal) maxVal = x;
  }
  print('e. Phần tử lớn nhất trong danh sách: $maxVal');

  // f. Tìm số chẵn lớn nhất
  int? maxChan;
  for (int x in ds) {
    if (x % 2 == 0) {
      if (maxChan == null || x > maxChan) {
        maxChan = x;
      }
    }
  }
  if (maxChan == null) {
    print('f. Thông báo: Danh sách không có số chẵn.');
  } else {
    print('f. Phần tử là số chẵn lớn nhất: $maxChan');
  }

  // g. Nhập giá trị, kiểm tra và xóa các phần tử trùng lặp
  stdout.write('g. Nhập một giá trị cần tìm: ');
  int val = int.parse(stdin.readLineSync()!);

  if (ds.contains(val)) {
    ds.removeWhere((element) => element == val);
    print('-> Đã tìm thấy $val. Đã xóa tất cả phần tử có giá trị $val.');
    print('   Danh sách sau khi xóa: $ds');
  } else {
    print('-> Thông báo: Không tìm thấy.');
  }
}

// Bài 2: Xử lý chuỗi ký tự
void baiTapVeNha2() {
  print('--- II. BÀI TẬP VỀ NHÀ - BÀI 2: XỬ LÝ CHUỖI ---');

  // a. Nhập vào 1 chuỗi và xuất chuỗi đó ra màn hình
  stdout.write('a. Nhập vào 1 chuỗi: ');
  String str = stdin.readLineSync()!;
  print('   Chuỗi vừa nhập: "$str"');

  // b. Đếm số ký tự là nguyên âm
  String nguyenAm = 'aeiouAEIOU';
  int demNguyenAm = 0;
  for (int i = 0; i < str.length; i++) {
    if (nguyenAm.contains(str[i])) {
      demNguyenAm++;
    }
  }
  print('b. Số ký tự là nguyên âm: $demNguyenAm');

  // c. Đếm số từ trong chuỗi
  List<String> dsTu = str.trim().split(RegExp(r'\s+'));
  if (str.trim().isEmpty) dsTu = [];
  print('c. Số từ trong chuỗi: ${dsTu.length}');

  // d. Kiểm tra chuỗi đối xứng (Không xét khoảng trắng và chữ hoa/thường)
  String strClean = str.replaceAll(' ', '').toLowerCase();
  String strDao = strClean.split('').reversed.join('');
  bool doiXung = (strClean.isNotEmpty && strClean == strDao);
  print('d. Chuỗi có đối xứng hay không: ${doiXung ? "CÓ" : "KHÔNG"}');

  // e. Đảo ngược từ trong chuỗi (Ví dụ: "Bò ăn cỏ" -> "cỏ ăn Bò")
  String chuoiDaoTu = dsTu.reversed.join(' ');
  print('e. Chuỗi sau khi đảo ngược từ: "$chuoiDaoTu"');
}