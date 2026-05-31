import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  State<PusatBantuanScreen> createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqList = [
    {
      'q': 'Bagaimana cara membuat laporan?',
      'a':
          'Tap tombol "BUAT LAPORAN BARU" di halaman Beranda, isi semua form yang tersedia termasuk foto, kategori, judul, detail, dan lokasi, kemudian tap "KIRIM LAPORAN".',
    },
    {
      'q': 'Berapa lama laporan saya diproses?',
      'a':
          'Laporan akan diproses dalam 3-7 hari kerja. Anda akan mendapat notifikasi saat status laporan berubah.',
    },
    {
      'q': 'Bagaimana cara melihat status laporan?',
      'a':
          'Buka halaman "Laporan Saya" untuk melihat semua laporan Anda beserta statusnya. Status terdiri dari "Diproses" dan "Selesai".',
    },
    {
      'q': 'Apakah saya bisa melihat laporan warga lain?',
      'a':
          'Ya, tap tombol "LIHAT LAPORAN WARGA" di halaman Beranda untuk melihat semua laporan yang telah dikirim oleh warga lain.',
    },
    {
      'q': 'Bagaimana jika saya lupa password?',
      'a':
          'Tap "Lupa Password?" di halaman login, kemudian masukkan email Anda untuk mendapatkan link reset password.',
    },
    {
      'q': 'Apakah data saya aman?',
      'a':
          'Ya, data Anda dienkripsi dan disimpan dengan aman. Kami tidak akan membagikan data pribadi Anda kepada pihak ketiga.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Pusat Bantuan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7)
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.support_agent, color: Colors.white, size: 36),
                  SizedBox(height: 10),
                  Text(
                    'Ada yang bisa kami bantu?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Temukan jawaban atas pertanyaan Anda di sini.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQ
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'PERTANYAAN UMUM (FAQ)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...List.generate(_faqList.length, (index) {
              final isExpanded = _expandedIndex == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isExpanded
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        _faqList[index]['q']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isExpanded
                              ? AppColors.primary
                              : AppColors.textDark,
                        ),
                      ),
                      trailing: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: isExpanded
                              ? AppColors.primary
                              : AppColors.textGrey,
                        ),
                      ),
                      onTap: () => setState(
                          () => _expandedIndex = isExpanded ? null : index),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          _faqList[index]['a']!,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey,
                              height: 1.5),
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Kontak
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'HUBUNGI KAMI',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildKontakTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'bantuan@infrastruktur.solo.go.id',
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildKontakTile(
              icon: Icons.phone_outlined,
              label: 'Telepon',
              value: '(0271) 123-4567',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildKontakTile(
              icon: Icons.access_time,
              label: 'Jam Layanan',
              value: 'Senin - Jumat, 08.00 - 16.00 WIB',
              color: AppColors.statusDiproses,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildKontakTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
