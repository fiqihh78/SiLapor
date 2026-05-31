import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/laporan_model.dart';
import '../../providers/app_provider.dart';

class BuatLaporanScreen extends StatefulWidget {
  const BuatLaporanScreen({super.key});

  @override
  State<BuatLaporanScreen> createState() => _BuatLaporanScreenState();
}

class _BuatLaporanScreenState extends State<BuatLaporanScreen> {
  String? _selectedKategori;
  final _judulController = TextEditingController();
  final _detailController = TextEditingController();
  final _alamatController = TextEditingController();

  File? _selectedImage;
  double? _lat, _lng;
  bool _isLoadingLokasi = false;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  final List<String> _kategoriList = [
    'Jalan Berlubang',
    'Lampu Jalan Rusak',
    'Drainase Tersumbat',
    'Trotoar Rusak',
    'Fasilitas Umum',
  ];

  @override
  void dispose() {
    _judulController.dispose();
    _detailController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _showSnackbar(String pesan, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: isError ? Colors.red : AppColors.statusSelesai,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── PILIH FOTO ──
  void _showPilihFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text('Buka Kamera',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Ambil foto langsung'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 300));
                _ambilFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text('Pilih dari Galeri',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Pilih foto yang sudah ada'),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 300));
                _ambilFoto(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _ambilFoto(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (file != null && mounted) {
        setState(() => _selectedImage = File(file.path));
        _showSnackbar('Foto berhasil ditambahkan!');
      }
    } catch (e) {
      debugPrint('Error ambil foto: $e');
      if (mounted) {
        _showSnackbar(
          'Gagal mengambil foto. Pastikan izin kamera/galeri sudah diaktifkan di Pengaturan.',
          isError: true,
        );
      }
    }
  }

  // ── LOKASI ──
  Future<void> _ambilLokasi() async {
    setState(() => _isLoadingLokasi = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackbar('GPS tidak aktif. Aktifkan lokasi di pengaturan.',
            isError: true);
        setState(() => _isLoadingLokasi = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackbar('Izin lokasi ditolak.', isError: true);
          setState(() => _isLoadingLokasi = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackbar(
            'Izin lokasi ditolak permanen. Aktifkan di Pengaturan > Aplikasi.',
            isError: true);
        setState(() => _isLoadingLokasi = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
        ].where((p) => p != null && p.isNotEmpty).toList();

        final alamat = parts.join(', ');

        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
          _alamatController.text = alamat;
          _isLoadingLokasi = false;
        });

        _showSnackbar('Lokasi berhasil didapatkan!');
      }
    } catch (e) {
      debugPrint('Error lokasi: $e');
      if (mounted) {
        _showSnackbar('Gagal mendapatkan lokasi. Coba lagi.', isError: true);
        setState(() => _isLoadingLokasi = false);
      }
    }
  }

  // ── KIRIM LAPORAN ──
  Future<void> _kirimLaporan() async {
    if (_selectedKategori == null) {
      _showSnackbar('Pilih kategori laporan!', isError: true);
      return;
    }
    if (_judulController.text.trim().isEmpty) {
      _showSnackbar('Judul laporan tidak boleh kosong!', isError: true);
      return;
    }
    if (_alamatController.text.trim().isEmpty) {
      _showSnackbar('Alamat lokasi tidak boleh kosong!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final laporan = LaporanModel(
      id: now.millisecondsSinceEpoch.toString(),
      kategori: _selectedKategori!,
      judul: _judulController.text.trim(),
      detail: _detailController.text.trim(),
      lokasi: _alamatController.text.trim(),
      tanggal: _formatTanggal(now),
      status: 'Laporan Terkirim',
      imagePath: _selectedImage?.path,
    );

    if (!mounted) return;
    context.read<AppProvider>().tambahLaporan(laporan);

    setState(() => _isLoading = false);
    _showSnackbar('Laporan berhasil dikirim!');

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) Navigator.pop(context);
  }

  String _formatTanggal(DateTime dt) {
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    const hari = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    return '${hari[dt.weekday % 7]}, ${dt.day} ${bulan[dt.month]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Buat Laporan Baru',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── FOTO ──
            const Text('Foto Laporan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showPilihFoto,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedImage != null
                        ? AppColors.primary
                        : Colors.grey[350]!,
                    width: _selectedImage != null ? 2 : 1,
                  ),
                ),
                child: _selectedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 180,
                            ),
                          ),
                          // Tombol hapus foto
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          // Tombol ganti foto
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _showPilihFoto,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit,
                                        color: Colors.white, size: 14),
                                    SizedBox(width: 4),
                                    Text('Ganti',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              color: Colors.grey[400], size: 48),
                          const SizedBox(height: 10),
                          Text(
                            'Tap untuk tambah foto',
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kamera atau Galeri',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // ── KATEGORI ──
            const Text('Kategori Laporan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedKategori,
              hint: const Text('Pilih Kategori'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              items: _kategoriList
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedKategori = val),
            ),
            const SizedBox(height: 16),

            // ── JUDUL ──
            const Text('Judul Laporan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                hintText: 'Masukkan judul laporan',
              ),
            ),
            const SizedBox(height: 16),

            // ── DETAIL ──
            const Text('Detail Laporan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _detailController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kondisi secara detail...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // ── ALAMAT ──
            const Text('Alamat Lokasi',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _alamatController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Ketik alamat atau gunakan lokasi otomatis',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoadingLokasi ? null : _ambilLokasi,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _lat != null
                          ? AppColors.statusSelesai.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _lat != null
                            ? AppColors.statusSelesai.withOpacity(0.4)
                            : AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: _isLoadingLokasi
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: AppColors.primary),
                          )
                        : Icon(
                            _lat != null
                                ? Icons.location_on
                                : Icons.my_location,
                            color: _lat != null
                                ? AppColors.statusSelesai
                                : AppColors.primary,
                            size: 26,
                          ),
                  ),
                ),
              ],
            ),
            if (_lat != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.statusSelesai, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'GPS: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
                    style: const TextStyle(
                        color: AppColors.statusSelesai, fontSize: 11),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),

            // ── KIRIM ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _kirimLaporan,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'KIRIM LAPORAN',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
