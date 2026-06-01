import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  static const _storage  = FlutterSecureStorage();
  static const _tokenKey = 'api_token';

  // ── TOKEN ─────────────────────────────────────────────────────────────
  static Future<void>    simpanToken(String t) => _storage.write(key: _tokenKey, value: t);
  static Future<String?> ambilToken()          => _storage.read(key: _tokenKey);
  static Future<void>    hapusToken()          => _storage.delete(key: _tokenKey);

  static Future<Map<String, String>> _headers() async {
    final token = await ambilToken();
    return {
      'Content-Type': 'application/json',
      'Accept':       'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── AUTH ──────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 201 && data['success'] == true) {
      await simpanToken(data['token']);
    }
    return data;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200 && data['success'] == true) {
      await simpanToken(data['token']);
    }
    return data;
  }

  static Future<void> logout() async {
    final headers = await _headers();
    try {
      await http.post(Uri.parse(ApiConstants.logout), headers: headers);
    } catch (_) {}
    await hapusToken();
  }

  static Future<Map<String, dynamic>> getMe() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse(ApiConstants.me), headers: headers);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── KATEGORI ──────────────────────────────────────────────────────────
  static Future<List<dynamic>> getKategori() async {
    final headers = await _headers();
    final res  = await http.get(Uri.parse(ApiConstants.kategori), headers: headers);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['kategoris'] ?? [];
  }

  // ── LAPORAN ───────────────────────────────────────────────────────────
  static Future<List<dynamic>> getLaporan() async {
    final headers = await _headers();
    final res  = await http.get(Uri.parse(ApiConstants.laporan), headers: headers);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['laporans'] ?? [];
  }

  static Future<List<dynamic>> getSemuaLaporan() async {
    final headers = await _headers();
    final res  = await http.get(Uri.parse(ApiConstants.semuaLaporan), headers: headers);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['laporans'] ?? [];
  }

  static Future<Map<String, dynamic>> getLaporanDetail(int id) async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.laporan}/$id'),
      headers: headers,
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Kirim laporan baru (multipart — support upload foto)
  static Future<Map<String, dynamic>> kirimLaporan({
    required int    kategoriId,
    required String judul,
    required String deskripsi,
    required String lokasi,
    File?           foto,
  }) async {
    final token   = await ambilToken();
    final request = http.MultipartRequest('POST', Uri.parse(ApiConstants.laporan));

    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    request.fields['kategori_id'] = kategoriId.toString();
    request.fields['judul']       = judul;
    request.fields['deskripsi']   = deskripsi;
    request.fields['lokasi']      = lokasi;

    if (foto != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto_sebelum', foto.path),
      );
    }

    final streamed = await request.send();
    final res      = await http.Response.fromStream(streamed);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  // ── NOTIFIKASI ────────────────────────────────────────────────────────
  static Future<List<dynamic>> getNotifikasi() async {
    final headers = await _headers();
    final res  = await http.get(Uri.parse(ApiConstants.notifikasi), headers: headers);
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data['notifikasis'] ?? [];
  }

  static Future<void> tandaiSemuaDibaca() async {
    final headers = await _headers();
    await http.post(
      Uri.parse('${ApiConstants.notifikasi}/tandai-semua'),
      headers: headers,
    );
  }

  static Future<void> tandaiSatuDibaca(String id) async {
    final headers = await _headers();
    await http.post(
      Uri.parse('${ApiConstants.notifikasi}/$id/baca'),
      headers: headers,
    );
  }
}
