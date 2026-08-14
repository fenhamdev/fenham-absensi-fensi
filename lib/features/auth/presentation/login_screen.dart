import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/user_profile.dart';
import '../../attendance/presentation/attendance_screen.dart';
import '../../admin/presentation/admin_layout.dart';

final currentProfileProvider = StateProvider<UserProfile?>((ref) => null);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'karyawan@fenham.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  String _selectedRole = 'employee'; // 'employee' or 'admin'

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Demo authentication & routing
    final profile = UserProfile(
      id: _selectedRole == 'admin' ? 'admin-123' : 'emp-456',
      fullName: _selectedRole == 'admin' ? 'Budi Santoso (Admin HC)' : 'Ahmad Fauzi (Karyawan)',
      email: _emailController.text,
      role: _selectedRole,
      department: _selectedRole == 'admin' ? 'Human Capital' : 'Software Engineering',
      quotaCuti: 12,
    );

    ref.read(currentProfileProvider.notifier).state = profile;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (_selectedRole == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminLayout()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AttendanceScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.neutralBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(15, 23, 42, 0.05),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Header Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNavy,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'FENSI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryNavy,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Fenham Absensi & Human Capital Management',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Role Selector Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.softBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'employee'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'employee' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedRole == 'employee'
                                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                                    : null,
                              ),
                              child: Text(
                                'Karyawan (Mobile)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedRole == 'employee' ? AppTheme.primaryNavy : AppTheme.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'admin'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'admin' ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedRole == 'admin'
                                    ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                                    : null,
                              ),
                              child: Text(
                                'Admin HC (Web)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedRole == 'admin' ? AppTheme.primaryNavy : AppTheme.textMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: 'Email Perusahaan',
                    hint: 'nama@fenham.com',
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outlined, size: 20, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Masuk ke Aplikasi',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                    icon: Icons.login_rounded,
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
