class ChuyenNganh {
  final String maCN;
  final String tenCN;
  final String moTa;

  const ChuyenNganh({
    required this.maCN,
    required this.tenCN,
    required this.moTa,
  });

  factory ChuyenNganh.fromJson(Map<String, dynamic> json) {
    return ChuyenNganh(
      maCN: (json['maCN'] ?? json['MaCN'] ?? '').toString(),
      tenCN: (json['tenCN'] ?? json['TenCN'] ?? '').toString(),
      moTa: (json['moTa'] ?? json['MoTa'] ?? '').toString(),
    );
  }
}