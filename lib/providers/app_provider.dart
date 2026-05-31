import 'package:flutter/material.dart';
import '../models/laporan_model.dart';
import '../models/notifikasi_model.dart';

class AppProvider extends ChangeNotifier {
  // ── USER ──
  String _namaUser = '';
  String _emailUser = '';
  String? _fotoProfil;

  String get namaUser => _namaUser;
  String get emailUser => _emailUser;
  String? get fotoProfil => _fotoProfil;

  void setUser(String nama, String email) {
    _namaUser = nama;
    _emailUser = email;
    notifyListeners();
  }

  void setFotoProfil(String path) {
    _fotoProfil = path;
    notifyListeners();
  }

  void hapusFotoProfil() {
    _fotoProfil = null;
    notifyListeners();
  }

  // ── LAPORAN ──
  final List<LaporanModel> _laporanList = [];

  List<LaporanModel> get laporanList => _laporanList;
  int get totalLaporan => _laporanList.length;
  int get totalDiproses =>
      _laporanList.where((l) => l.status == 'Diproses').length;
  int get totalSelesai =>
      _laporanList.where((l) => l.status == 'Selesai').length;

  void tambahLaporan(LaporanModel laporan) {
    _laporanList.insert(0, laporan);
    _tambahNotifikasi(
      judul: 'Laporan Dikirim!',
      pesan: 'Laporan "${laporan.judul}" berhasil dikirim dan sedang diproses.',
    );
    notifyListeners();
  }

  // ── NOTIFIKASI ──
  final List<NotifikasiModel> _notifikasiList = [];

  List<NotifikasiModel> get notifikasiList => _notifikasiList;
  int get jumlahBelumDibaca =>
      _notifikasiList.where((n) => !n.sudahDibaca).length;

  void _tambahNotifikasi({required String judul, required String pesan}) {
    _notifikasiList.insert(
      0,
      NotifikasiModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        judul: judul,
        pesan: pesan,
        waktu: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void tandaiSemuaDibaca() {
    for (var n in _notifikasiList) {
      n.sudahDibaca = true;
    }
    notifyListeners();
  }

  void tandaiSatuDibaca(String id) {
    final index = _notifikasiList.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifikasiList[index].sudahDibaca = true;
      notifyListeners();
    }
  }

  // ── LOGOUT ──
  void logout() {
    _namaUser = '';
    _emailUser = '';
    _fotoProfil = null;
    _laporanList.clear();
    _notifikasiList.clear();
    notifyListeners();
  }
}
