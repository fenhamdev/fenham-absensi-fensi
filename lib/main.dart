import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/models/user_profile.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/attendance/presentation/attendance_screen.dart';
import 'features/admin/presentation/admin_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale Bahasa Indonesia untuk format tanggal (perbaiki layar abu-abu)
  await initializeDateFormatting('id_ID', null);

  try {
    await SupabaseConfig.initialize();
  } catch (e) {
    debugPrint('Note: Running FENSI with local demo mode ($e)');
  }

  // Cek sesi login tersimpan
  final prefs = await SharedPreferences.getInstance();
  final String? savedRole = prefs.getString('session_role');
  final String? savedName = prefs.getString('session_name');
  final String? savedEmail = prefs.getString('session_email');
  final String? savedDept = prefs.getString('session_department');

  UserProfile? savedProfile;
  if (savedRole != null && savedName != null) {
    savedProfile = UserProfile(
      id: prefs.getString('session_id') ?? 'local-user',
      fullName: savedName,
      email: savedEmail,
      role: savedRole,
      department: savedDept ?? 'General',
      quotaCuti: prefs.getInt('session_quota') ?? 12,
    );
  }

  runApp(
    ProviderScope(
      child: FensiApp(savedProfile: savedProfile),
    ),
  );
}

class FensiApp extends ConsumerWidget {
  final UserProfile? savedProfile;
  const FensiApp({Key? key, this.savedProfile}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Jika ada sesi tersimpan, set ke provider dan langsung ke halaman utama
    if (savedProfile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentProfileProvider.notifier).state = savedProfile;
      });
    }

    return MaterialApp(
      title: 'FENSI - Fenham Absensi & HC System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Otomatis mengikuti setelan tema HP (Light/Dark)
      themeMode: ThemeMode.system,
      home: savedProfile == null
          ? const LoginScreen()
          : savedProfile!.isAdmin
              ? const AdminLayout()
              : const AttendanceScreen(),
    );
  }
}
