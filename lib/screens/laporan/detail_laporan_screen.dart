import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/laporan_model.dart';

class DetailLaporanScreen extends StatelessWidget {
  final LaporanModel laporan;

  const DetailLaporanScreen({super.key, required this.laporan});

  Color _statusColor(String status) {
    switch (status) {
      case 'Laporan Terkirim':
        return AppColors.statusDiproses;
      case 'Selesai':
        return AppColors.statusSelesai;
      default:
        return AppColors.statusLaporan;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Laporan Terkirim':
        return Icons.send;
      case 'Diproses':
        return Icons.hourglass_empty;
      case 'Selesai':
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Detail Laporan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── FOTO ──
            if (laporan.imagePath != null)
              GestureDetector(
                onTap: () => _lihatFotoFullscreen(context),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.black,
                      child: Image.file(
                        File(laporan.imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported_outlined,
                              size: 48, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
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
                            Icon(Icons.fullscreen,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Lihat Foto',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 140,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined,
                        size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada foto',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── STATUS & KATEGORI ──
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(laporan.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(laporan.status),
                                color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              laporan.status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          laporan.kategori,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── JUDUL ──
                  Text(
                    laporan.judul,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),

                  // ── INFO CARD ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          'Tanggal Laporan',
                          laporan.tanggal,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          'Lokasi',
                          laporan.lokasi,
                        ),
                        const Divider(height: 20),
                        _buildInfoRow(
                          Icons.tag,
                          'ID Laporan',
                          '#${laporan.id.substring(laporan.id.length > 8 ? laporan.id.length - 8 : 0)}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── DESKRIPSI ──
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      laporan.detail.isNotEmpty
                          ? laporan.detail
                          : 'Tidak ada deskripsi tambahan.',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textGrey, height: 1.6),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── TIMELINE ──
                  const Text(
                    'Status Laporan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  _buildTimeline(laporan.status),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, height: 1.4),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(String status) {
    final steps = [
      {
        'label': 'Laporan Dikirim',
        'sub': 'Laporan berhasil diterima sistem',
        'done': true
      },
      {
        'label': 'Sedang Diproses',
        'sub': 'Tim sedang menindaklanjuti laporan',
        'done': status == 'Diproses' || status == 'Selesai',
      },
      {
        'label': 'Perbaikan Selesai',
        'sub': 'Masalah telah berhasil diselesaikan',
        'done': status == 'Selesai',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final isDone = steps[index]['done'] as bool;
          final isLast = index == steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color:
                          isDone ? AppColors.statusSelesai : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.check : Icons.circle,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 36,
                      color:
                          isDone ? AppColors.statusSelesai : Colors.grey[300],
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index]['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color:
                              isDone ? AppColors.textDark : AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        steps[index]['sub'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDone ? AppColors.textGrey : Colors.grey[400],
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _lihatFotoFullscreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Foto Laporan',
                style: TextStyle(color: Colors.white)),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.file(File(laporan.imagePath!)),
            ),
          ),
        ),
      ),
    );
  }
}
