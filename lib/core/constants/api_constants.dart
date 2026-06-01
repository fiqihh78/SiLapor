class ApiConstants {
  // ── URL PRODUCTION (Railway) ──────────────────────────────────────────
  static const String baseUrl =
      'https://sistem-pelaporan-production.up.railway.app/api';

  // ── AUTH ──────────────────────────────────────────────────────────────
  static const String register = '$baseUrl/register';
  static const String login    = '$baseUrl/login';
  static const String logout   = '$baseUrl/logout';
  static const String me       = '$baseUrl/me';

  // ── LAPORAN ───────────────────────────────────────────────────────────
  static const String laporan      = '$baseUrl/laporan';
  static const String semuaLaporan = '$baseUrl/laporan/semua';

  // ── KATEGORI ──────────────────────────────────────────────────────────
  static const String kategori = '$baseUrl/kategori';

  // ── NOTIFIKASI ────────────────────────────────────────────────────────
  static const String notifikasi = '$baseUrl/notifikasi';
}
