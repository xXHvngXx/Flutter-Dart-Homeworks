class DeTai{
  String _maDeTai;
  String _tenDeTai;
  String _tenGiangVien;
  String _noiDung;
  String _chuyenNganh;

  DeTai(
    {
      required String maDeTai,
      required String tenDeTai,
      required tenGiangVien,
      required noiDung,
      required String chuyenNganh,}) : 
      _chuyenNganh = chuyenNganh,
      _noiDung = noiDung,
      _tenDeTai = tenDeTai,
      _tenGiangVien = tenGiangVien,
      _maDeTai = maDeTai;
    String get getMaDeTai =>_maDeTai;
    String get tenDeTai => _tenDeTai;
    String get tenGiangVien => _tenGiangVien;
    String get noiDung => _noiDung;
    String get chuyenNganh => _chuyenNganh;
}