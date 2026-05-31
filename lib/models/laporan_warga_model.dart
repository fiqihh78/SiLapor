class LaporanWargaModel {
  final String id;
  final String namaWarga;
  final String kategori;
  final String judul;
  final String detail;
  final String lokasi;
  final String tanggal;
  final String status;

  LaporanWargaModel({
    required this.id,
    required this.namaWarga,
    required this.kategori,
    required this.judul,
    required this.detail,
    required this.lokasi,
    required this.tanggal,
    required this.status,
  });
}

final List<LaporanWargaModel> dummyLaporanWarga = [
  LaporanWargaModel(
    id: 'w1',
    namaWarga: 'Budi Santoso',
    kategori: 'Jalan Berlubang',
    judul: 'Jalan Berlubang Sangat Dalam',
    detail: 'Terdapat lubang besar di tengah jalan yang sangat berbahaya.',
    lokasi: 'Jl. Brigjen Katamso No. 12',
    tanggal: 'Sen, 6 Jan 2025',
    status: 'Diproses',
  ),
  LaporanWargaModel(
    id: 'w2',
    namaWarga: 'Siti Rahayu',
    kategori: 'Lampu Jalan Rusak',
    judul: 'Lampu Jalan Mati 3 Hari',
    detail: 'Lampu jalan di depan gang sudah mati sejak 3 hari lalu.',
    lokasi: 'Jl. Dr. Rajiman No. 5',
    tanggal: 'Sel, 7 Jan 2025',
    status: 'Selesai',
  ),
  LaporanWargaModel(
    id: 'w3',
    namaWarga: 'Agus Purnomo',
    kategori: 'Drainase Tersumbat',
    judul: 'Saluran Air Mampet',
    detail: 'Drainase depan rumah tersumbat sampah, air meluber ke jalan.',
    lokasi: 'Jl. Veteran No. 33',
    tanggal: 'Rab, 8 Jan 2025',
    status: 'Diproses',
  ),
  LaporanWargaModel(
    id: 'w4',
    namaWarga: 'Dewi Lestari',
    kategori: 'Trotoar Rusak',
    judul: 'Trotoar Retak Berbahaya',
    detail: 'Trotoar retak parah, sudah ada warga yang tersandung.',
    lokasi: 'Jl. Slamet Riyadi No. 88',
    tanggal: 'Kam, 9 Jan 2025',
    status: 'Diproses',
  ),
  LaporanWargaModel(
    id: 'w5',
    namaWarga: 'Rizky Aditya',
    kategori: 'Fasilitas Umum',
    judul: 'Bangku Taman Rusak',
    detail: 'Bangku taman di alun-alun sudah rusak dan membahayakan.',
    lokasi: 'Alun-Alun Utara Solo',
    tanggal: 'Jum, 10 Jan 2025',
    status: 'Selesai',
  ),
  LaporanWargaModel(
    id: 'w6',
    namaWarga: 'Hendra Wijaya',
    kategori: 'Jalan Berlubang',
    judul: 'Lubang Jalan Dekat Pasar',
    detail: 'Banyak lubang di jalan dekat pasar, membahayakan pengendara.',
    lokasi: 'Jl. Pasar Kliwon No. 2',
    tanggal: 'Sab, 11 Jan 2025',
    status: 'Diproses',
  ),
];
