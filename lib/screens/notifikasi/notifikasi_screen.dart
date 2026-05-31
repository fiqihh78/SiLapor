import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  String _formatWaktu(DateTime waktu) {
    final now = DateTime.now();
    final diff = now.difference(waktu);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Notifikasi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<AppProvider>().tandaiSemuaDibaca(),
            child: const Text('Tandai dibaca',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.notifikasiList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 72, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Belum ada notifikasi',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifikasiList.length,
            itemBuilder: (context, index) {
              final notif = provider.notifikasiList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: notif.sudahDibaca
                      ? AppColors.white
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: notif.sudahDibaca
                        ? AppColors.divider
                        : AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notif.sudahDibaca
                        ? Colors.grey[200]
                        : AppColors.primary.withOpacity(0.15),
                    child: Icon(Icons.notifications,
                        color:
                            notif.sudahDibaca ? Colors.grey : AppColors.primary,
                        size: 20),
                  ),
                  title: Text(notif.judul,
                      style: TextStyle(
                          fontWeight: notif.sudahDibaca
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(notif.pesan, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(_formatWaktu(notif.waktu),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
