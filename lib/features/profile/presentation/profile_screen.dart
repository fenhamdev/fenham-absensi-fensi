import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_card.dart';
import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // User Avatar & Name
          CircleAvatar(
            radius: 44,
            backgroundColor: AppTheme.primaryNavy,
            child: Text(
              profile?.fullName.substring(0, 1) ?? 'F',
              style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile?.fullName ?? 'Karyawan Fenham',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          Text(
            '${profile?.department ?? 'General'} • Role: ${profile?.role.toUpperCase()}',
            style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),

          // Detail Karyawan Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Karyawan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                ),
                const Divider(height: 24),
                _buildInfoTile(Icons.badge_outlined, 'NIK / ID Karyawan', '2026-081499'),
                _buildInfoTile(Icons.email_outlined, 'Email', profile?.email ?? 'karyawan@fenham.com'),
                _buildInfoTile(Icons.phone_android, 'No. Handphone', '+62 812-3456-7890'),
                _buildInfoTile(Icons.work_outline, 'Departemen', profile?.department ?? 'General'),
                _buildInfoTile(Icons.event_available, 'Sisa Kuota Cuti', '${profile?.quotaCuti ?? 12} Hari'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Detail Perusahaan Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Perusahaan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                ),
                const Divider(height: 24),
                _buildInfoTile(Icons.business, 'Nama PT', 'PT. Fenham Indonesia Utama'),
                _buildInfoTile(Icons.location_city, 'Alamat Kantor', 'Jl. Pogung Raya No. 171 B, Pogung Kidul, Sinduadi, Mlati, Sleman, DI Yogyakarta'),
                _buildInfoTile(Icons.my_location, 'Koordinat Kantor', '-7.7543, 110.3762 (Radius 150m)'),
                _buildInfoTile(Icons.access_time, 'Jam Kerja Standard', 'Senin - Jumat (08:00 - 17:00 WIB)'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.roseDanger,
                side: const BorderSide(color: AppTheme.roseDanger),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar dari Akun (Logout)', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryNavy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.slateGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
