class LaporanModel {
  final String id;
  final String kategori;
  final String judul;
  final String detail;
  final String lokasi;
  final String tanggal;
  String status;
  final String? imagePath;

  LaporanModel({
    required this.id,
    required this.kategori,
    required this.judul,
    this.detail = '',
    required this.lokasi,
    required this.tanggal,
    this.status = 'Diproses',
    this.imagePath,
  });
}

final List<LaporanModel> dummyLaporan = [];
