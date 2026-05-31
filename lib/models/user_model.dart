class UserModel {
  final String id;
  final String nama;
  final String email;
  final String instansi;
  final int totalLaporan;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.instansi,
    required this.totalLaporan,
    required this.isVerified,
  });
}

final UserModel dummyUser = UserModel(
  id: '1',
  nama: 'Armadhito',
  email: 'armadhito.prakoso@solo.go.id',
  instansi: 'Pemerintah Kota Surakarta',
  totalLaporan: 12,
  isVerified: true,
);
