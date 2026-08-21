import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/user_profile.dart';
import '../../attendance/presentation/attendance_screen.dart';
import '../../admin/presentation/admin_layout.dart';

final currentProfileProvider = StateProvider<UserProfile?>((ref) => null);

// ─── Daftar akun demo lokal (fallback jika Supabase tidak tersedia) ───────────
const List<Map<String, dynamic>> _demoAccounts = [
  {
    'id': 'admin-001',
    'email': 'admin@fenham.com',
    'password': 'password123',
    'full_name': 'Budi Santoso (Admin HC)',
    'role': 'admin',
    'department': 'Human Capital',
    'quota_cuti': 12,
  },
  {
    'id': 'emp-001',
    'email': 'ahmad.fauzi@fenham.com',
    'password': 'password123',
    'full_name': 'Ahmad Fauzi',
    'role': 'employee',
    'department': 'Software Engineering',
    'quota_cuti': 12,
  },
  {
    'id': 'emp-002',
    'email': 'siti.nurhaliza@fenham.com',
    'password': 'password123',
    'full_name': 'Siti Nurhaliza',
    'role': 'employee',
    'department': 'Human Capital',
    'quota_cuti': 10,
  },
  {
    'id': 'emp-003',
    'email': 'rian.hidayat@fenham.com',
    'password': 'password123',
    'full_name': 'Rian Hidayat',
    'role': 'employee',
    'department': 'Finance',
    'quota_cuti': 8,
  },
];

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controller kosong — tidak ada teks default yang menempel
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true; // Sembunyikan password secara default
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    UserProfile? profile;

    // ── 1. Coba login ke Supabase Auth terlebih dahulu ─────────────────────
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final data = await SupabaseConfig.client
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();
        if (data != null) {
          profile = UserProfile.fromJson(data);
        }
      }
    } catch (_) {
      // Supabase tidak tersedia atau gagal — lanjut ke fallback lokal
    }

    // ── 2. Fallback: cocokkan ke daftar akun demo lokal ────────────────────
    if (profile == null) {
      final matches = _demoAccounts.where(
        (a) => a['email'] == email && a['password'] == password,
      );
      if (matches.isNotEmpty) {
        final acc = matches.first;
        profile = UserProfile(
          id: acc['id'],
          fullName: acc['full_name'],
          email: acc['email'],
          role: acc['role'],
          department: acc['department'],
          quotaCuti: acc['quota_cuti'],
        );
      }
    }

    if (!mounted) return;

    if (profile == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Email atau password salah. Silakan coba lagi.';
      });
      return;
    }

    // ── 3. Simpan sesi ke SharedPreferences ───────────────────────────────
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', profile.id);
    await prefs.setString('session_role', profile.role);
    await prefs.setString('session_name', profile.fullName);
    await prefs.setString('session_email', profile.email ?? '');
    await prefs.setString('session_department', profile.department);
    await prefs.setInt('session_quota', profile.quotaCuti);

    ref.read(currentProfileProvider.notifier).state = profile;

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (profile.isAdmin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminLayout()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AttendanceScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppTheme.darkSurface : Colors.white;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.neutralBorder;
    final labelColor = isDark ? AppTheme.darkTextPrimary : AppTheme.slateGray;
    final mutedColor = isDark ? AppTheme.darkTextMuted : AppTheme.textMuted;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.softBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black38
                        : const Color.fromRGBO(15, 23, 42, 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo / Header ─────────────────────────────────────
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.fingerprint,
                          size: 36, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'FENSI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Fenham Absensi & Human Capital Management',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: mutedColor),
                  ),
                  const SizedBox(height: 32),

                  // ── Email ─────────────────────────────────────────────
                  Text(
                    'Email Perusahaan',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: labelColor),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 14, color: labelColor),
                    decoration: InputDecoration(
                      hintText: 'contoh@fenham.com',
                      prefixIcon: Icon(Icons.email_outlined,
                          size: 20, color: mutedColor),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Password ──────────────────────────────────────────
                  Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: labelColor),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(fontSize: 14, color: labelColor),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: Icon(Icons.lock_outlined,
                          size: 20, color: mutedColor),
                      // ── Tombol sembunyikan / perlihatkan password ──────
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: mutedColor,
                        ),
                        tooltip: _obscurePassword
                            ? 'Perlihatkan password'
                            : 'Sembunyikan password',
                        onPressed: () {
                          setState(
                              () => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),

                  // ── Pesan error ───────────────────────────────────────
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.roseLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppTheme.roseDanger, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                  color: AppTheme.roseDanger, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ── Tombol Masuk ──────────────────────────────────────
                  CustomButton(
                    text: 'Masuk ke Aplikasi',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                    icon: Icons.login_rounded,
                  ),

                  const SizedBox(height: 20),

                  // ── Info akun demo ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkBackground
                          : AppTheme.softBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔑  Akun Demo Tersedia',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: mutedColor),
                        ),
                        const SizedBox(height: 4),
                        _demoRow('Admin HC', 'admin@fenham.com', mutedColor),
                        _demoRow('Karyawan 1', 'ahmad.fauzi@fenham.com',
                            mutedColor),
                        _demoRow('Karyawan 2', 'siti.nurhaliza@fenham.com',
                            mutedColor),
                        _demoRow('Karyawan 3', 'rian.hidayat@fenham.com',
                            mutedColor),
                        const SizedBox(height: 4),
                        Text(
                          'Password semua akun: password123',
                          style: TextStyle(fontSize: 11, color: mutedColor),
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

  Widget _demoRow(String label, String email, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Text('• $label: ',
              style: TextStyle(fontSize: 11, color: textColor)),
          Expanded(
            child: Text(
              email,
              style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
