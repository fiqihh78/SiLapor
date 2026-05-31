import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/laporan_warga_model.dart';
import 'detail_laporan_warga_screen.dart';

class SemuaLaporanWargaScreen extends StatefulWidget {
  const SemuaLaporanWargaScreen({super.key});

  @override
  State<SemuaLaporanWargaScreen> createState() =>
      _SemuaLaporanWargaScreenState();
}

class _SemuaLaporanWargaScreenState extends State<SemuaLaporanWargaScreen> {
  String _searchQuery = '';
  String _activeFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Diproses', 'Selesai'];

  List<LaporanWargaModel> get _filtered {
    List<LaporanWargaModel> result = List.from(dummyLaporanWarga);
    if (_activeFilter != 'Semua') {
      result = result.where((l) => l.status == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((l) =>
              l.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.lokasi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.namaWarga.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.kategori.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Laporan Warga',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── SEARCH ──
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari laporan atau nama warga...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: AppColors.background,
              ),
            ),
          ),

          // ── FILTER ──
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: _filters.map((filter) {
                final isActive = filter == _activeFilter;
                return GestureDetector(
                  onTap: () => setState(() => _activeFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} laporan ditemukan',
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),

          // ── LIST ──
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 72, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada laporan',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final l = _filtered[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailLaporanWargaScreen(laporan: l),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          padding: const EdgeInsets.all(14),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header: avatar + nama + status
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.15),
                                    child: Text(
                                      l.namaWarga[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l.namaWarga,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          l.tanggal,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textGrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _statusColor(l.status),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      l.status,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(height: 1),
                              const SizedBox(height: 10),

                              // Kategori
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l.kategori,
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Judul
                              Text(
                                l.judul,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 4),

                              // Detail singkat
                              Text(
                                l.detail,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textGrey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Lokasi + arrow
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 13, color: AppColors.textGrey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      l.lokasi,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textGrey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 12, color: AppColors.textGrey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
