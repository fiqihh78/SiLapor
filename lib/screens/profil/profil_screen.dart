import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../auth/login_screen.dart';
import '../notifikasi/notifikasi_screen.dart';
import 'pengaturan_akun_screen.dart';
import 'pusat_bantuan_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final ImagePicker _picker = ImagePicker();

  // ── PILIH FOTO PROFIL ──
  void _showPilihFotoProfil() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
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
              'Ganti Foto Profil',
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
            // Tombol hapus foto jika sudah ada
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.fotoProfil == null) return const SizedBox();
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text('Hapus Foto Profil',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AppProvider>().hapusFotoProfil();
                    _showSnackbar('Foto profil dihapus');
                  },
                );
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
        maxWidth: 512,
        maxHeight: 512,
      );
      if (file != null && mounted) {
        context.read<AppProvider>().setFotoProfil(file.path);
        _showSnackbar('Foto profil berhasil diperbarui!');
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar(
          'Gagal mengambil foto. Pastikan izin sudah diaktifkan.',
          isError: true,
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            title: const Text(
              'Profil Saya',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── PROFILE CARD ──
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: _showPilihFotoProfil,
                        child: Stack(
                          children: [
                            // Foto atau inisial
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.15),
                              backgroundImage: provider.fotoProfil != null
                                  ? FileImage(File(provider.fotoProfil!))
                                  : null,
                              child: provider.fotoProfil == null
                                  ? Text(
                                      provider.namaUser.isNotEmpty
                                          ? provider.namaUser[0].toUpperCase()
                                          : 'P',
                                      style: const TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : null,
                            ),

                            // Overlay gelap saat hover
                            Positioned.fill(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black.withOpacity(0.15),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),

                            // Badge kamera di pojok
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Tap untuk ganti foto
                      GestureDetector(
                        onTap: _showPilihFotoProfil,
                        child: const Text(
                          'Ganti Foto',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nama
                      Text(
                        provider.namaUser.isEmpty
                            ? 'Pengguna'
                            : provider.namaUser,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        provider.emailUser.isEmpty ? '-' : provider.emailUser,
                        style: const TextStyle(
                            color: AppColors.textGrey, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Statistik
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatBadge(
                            'Total',
                            '${provider.totalLaporan}',
                            Icons.assignment_outlined,
                            AppColors.statusLaporan,
                          ),
                          Container(
                              width: 1, height: 48, color: AppColors.divider),
                          _buildStatBadge(
                            'Diproses',
                            '${provider.totalDiproses}',
                            Icons.hourglass_empty,
                            AppColors.statusDiproses,
                          ),
                          Container(
                              width: 1, height: 48, color: AppColors.divider),
                          _buildStatBadge(
                            'Selesai',
                            '${provider.totalSelesai}',
                            Icons.check_circle_outline,
                            AppColors.statusSelesai,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── MENU ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'PREFERENSI & BANTUAN',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifikasi',
                        badge: provider.jumlahBelumDibaca > 0
                            ? provider.jumlahBelumDibaca
                            : null,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotifikasiScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.manage_accounts_outlined,
                        label: 'Pengaturan Akun',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PengaturanAkunScreen()),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        label: 'Pusat Bantuan',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PusatBantuanScreen()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          'AKUN',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        icon: Icons.logout,
                        label: 'Keluar',
                        isDestructive: true,
                        onTap: () => _showKonfirmasiLogout(context, provider),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Infrastruktur Solo v1.0.0',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    bool isDestructive = false,
    VoidCallback? onTap,
    int? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
      child: ListTile(
        leading:
            Icon(icon, color: isDestructive ? Colors.red : AppColors.textDark),
        title: Text(
          label,
          style: TextStyle(
            color: isDestructive ? Colors.red : AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red : AppColors.textGrey,
              size: 20,
            ),
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showKonfirmasiLogout(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar dari Akun',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
