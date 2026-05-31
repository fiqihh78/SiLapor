import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/laporan_model.dart';
import '../../widgets/laporan_card.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class LaporanSayaScreen extends StatefulWidget {
  const LaporanSayaScreen({super.key});

  @override
  State<LaporanSayaScreen> createState() => _LaporanSayaScreenState();
}

class _LaporanSayaScreenState extends State<LaporanSayaScreen> {
  String _activeFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Dalam Proses', 'Selesai'];

  List<LaporanModel> _filteredLaporan(List<LaporanModel> semua) {
    if (_activeFilter == 'Semua') return semua;
    if (_activeFilter == 'Dalam Proses') {
      return semua.where((l) => l.status == 'Diproses').toList();
    }
    return semua.where((l) => l.status == 'Selesai').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final filtered = _filteredLaporan(provider.laporanList);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            title: const Text(
              'Laporan Saya',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: Column(
            children: [
              // Filter chips
              Container(
                color: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isActive = filter == _activeFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _activeFilter = filter),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color:
                                isActive ? AppColors.primary : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color:
                                  isActive ? Colors.white : AppColors.textGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(height: 1),

              // List laporan
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 72, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada laporan',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            LaporanCard(laporan: filtered[index]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
