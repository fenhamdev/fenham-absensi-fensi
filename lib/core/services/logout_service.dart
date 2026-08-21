import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/supabase_config.dart';
import '../../features/auth/presentation/login_screen.dart';

/// Fungsi logout terpusat:
/// 1. Hapus sesi dari SharedPreferences
/// 2. Keluar dari Supabase Auth (jika terhubung)
/// 3. Reset state profil
/// 4. Arahkan ke halaman login
Future<void> performLogout(BuildContext context, WidgetRef ref) async {
  // Hapus sesi lokal
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('session_id');
  await prefs.remove('session_role');
  await prefs.remove('session_name');
  await prefs.remove('session_email');
  await prefs.remove('session_department');
  await prefs.remove('session_quota');

  // Keluar dari Supabase (jika ada sesi aktif)
  try {
    await SupabaseConfig.client.auth.signOut();
  } catch (_) {
    // Abaikan jika Supabase tidak tersedia
  }

  // Reset state provider
  ref.read(currentProfileProvider.notifier).state = null;

  if (context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
