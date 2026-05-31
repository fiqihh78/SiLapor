import 'dart:io';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/laporan_model.dart';
import '../screens/laporan/detail_laporan_screen.dart';

class LaporanCard extends StatelessWidget {
  final LaporanModel laporan;

  const LaporanCard({super.key, required this.laporan});

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses':
        return AppColors.statusDiproses;
      case 'Selesai':
        return AppColors.statusSelesai;
      default:
        return AppColors.statusLaporan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailLaporanScreen(laporan: laporan),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: laporan.imagePath != null
                  ? Image.file(
                      File(laporan.imagePath!),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kategori: ${laporan.kategori}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textGrey)),
                  const SizedBox(height: 3),
                  Text(laporan.judul,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 11, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(laporan.tanggal,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textGrey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 11, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(laporan.lokasi,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textGrey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(laporan.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(laporan.status,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textGrey),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 70,
      height: 70,
      color: Colors.grey[200],
      child: const Icon(Icons.image, color: Colors.grey, size: 32),
    );
  }
}
