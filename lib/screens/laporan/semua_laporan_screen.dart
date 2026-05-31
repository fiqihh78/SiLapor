import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/laporan_model.dart';
import '../../widgets/laporan_card.dart';

class SemuaLaporanScreen extends StatefulWidget {
  const SemuaLaporanScreen({super.key});

  @override
  State<SemuaLaporanScreen> createState() => _SemuaLaporanScreenState();
}

class _SemuaLaporanScreenState extends State<SemuaLaporanScreen> {
  String _searchQuery = '';
  String _activeFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Diproses', 'Selesai'];

  List<LaporanModel> get _filteredLaporan {
    List<LaporanModel> result = List.from(dummyLaporan);

    if (_activeFilter != 'Semua') {
      result = result.where((l) => l.status == _activeFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((l) =>
              l.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.lokasi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              l.kategori.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Semua Laporan',
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
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari laporan...',
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textGrey),
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

          // Filter chips
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_filteredLaporan.length} laporan ditemukan',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredLaporan.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 72, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada laporan ditemukan',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba ubah filter atau kata kunci',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: _filteredLaporan.length,
                    itemBuilder: (context, index) =>
                        LaporanCard(laporan: _filteredLaporan[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
