import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  bool _isRegister = false;
  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _showSnackbar(String pesan, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: isError ? Colors.red : AppColors.statusSelesai,
      ),
    );
  }

  void _submit() {
    // Validasi login
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackbar(
        'Email dan password tidak boleh kosong!',
        isError: true,
      );
      return;
    }

    if (_isRegister) {
      // Validasi register
      if (_namaController.text.trim().isEmpty) {
        _showSnackbar(
          'Nama tidak boleh kosong!',
          isError: true,
        );
        return;
      }

      if (_passwordController.text != _konfirmasiController.text) {
        _showSnackbar(
          'Password dan konfirmasi tidak cocok!',
          isError: true,
        );
        return;
      }

      if (_passwordController.text.length < 6) {
        _showSnackbar(
          'Password minimal 6 karakter!',
          isError: true,
        );
        return;
      }

      // Simpan user register
      context.read<AppProvider>().setUser(
            _namaController.text.trim(),
            _emailController.text.trim(),
          );

      _showSnackbar(
        'Akun berhasil dibuat! Selamat datang',
      );
    } else {
      // Login
      final nama = _emailController.text.split('@')[0];

      context.read<AppProvider>().setUser(
            nama,
            _emailController.text.trim(),
          );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/surakarta.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_ska.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 5),

                  // Judul
                  Text(
                    _isRegister ? 'Buat Akun Baru' : 'Masuk ke Akun',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _isRegister
                        ? 'Daftar untuk mulai membuat laporan'
                        : 'Masukkan email dan password Anda',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Card Login
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Nama
                        if (_isRegister) ...[
                          TextField(
                            controller: _namaController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Nama Lengkap',
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        // Konfirmasi Password
                        if (_isRegister) ...[
                          const SizedBox(height: 14),
                          TextField(
                            controller: _konfirmasiController,
                            obscureText: _obscureKonfirmasi,
                            decoration: InputDecoration(
                              hintText: 'Konfirmasi Password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureKonfirmasi
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureKonfirmasi = !_obscureKonfirmasi;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],

                        // Forgot Password
                        if (!_isRegister) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ] else
                          const SizedBox(height: 16),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              _isRegister ? 'Daftar' : 'Masuk',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isRegister
                                  ? 'Sudah punya akun? '
                                  : 'Belum punya akun? ',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isRegister = !_isRegister;

                                  _namaController.clear();

                                  _emailController.clear();

                                  _passwordController.clear();

                                  _konfirmasiController.clear();
                                });
                              },
                              child: Text(
                                _isRegister ? 'Masuk' : 'Daftar Sekarang',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
