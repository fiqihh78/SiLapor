class NotifikasiModel {
  final String id;
  final String judul;
  final String pesan;
  final DateTime waktu;
  bool sudahDibaca;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.sudahDibaca = false,
  });
}
