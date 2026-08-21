import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/logout_service.dart';
import 'views/dashboard_overview_view.dart';
import 'views/employee_management_view.dart';
import 'views/leave_approval_view.dart';
import 'views/announcement_management_view.dart';
import 'views/geofence_setting_view.dart';
import 'views/schedule_management_view.dart';
import '../../auth/presentation/login_screen.dart';

class AdminLayout extends ConsumerStatefulWidget {
  const AdminLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
    DashboardOverviewView(),
    EmployeeManagementView(),
    LeaveApprovalView(),
    ScheduleManagementView(),
    AnnouncementManagementView(),
    GeofenceSettingView(),
  ];

  final List<Map<String, dynamic>> _menuItems = const [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'title': 'Data Karyawan', 'icon': Icons.people_outline},
    {'title': 'Approval Cuti', 'icon': Icons.assignment_turned_in_outlined},
    {'title': 'Jadwal Shift', 'icon': Icons.calendar_month_outlined},
    {'title': 'Pengumuman', 'icon': Icons.campaign_outlined},
    {'title': 'Pengaturan Geofence', 'icon': Icons.location_on_outlined},
  ];

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text(
            'Apakah Anda yakin ingin keluar dari sesi ini?\nAnda akan diminta login kembali saat membuka aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.roseDanger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await performLogout(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sidebarBg = isDark ? AppTheme.darkSurface : AppTheme.slateGray;
    final headerBg = isDark ? AppTheme.darkCard : Colors.white;
    final headerBorder = isDark ? AppTheme.darkBorder : AppTheme.neutralBorder;
    final selectedTileColor =
        isDark ? AppTheme.darkNavy : AppTheme.primaryNavy;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.softBackground,
      body: Row(
        children: [
          // ── Sidebar Navigation Desktop ──────────────────────────────────
          Container(
            width: 260,
            decoration: BoxDecoration(color: sidebarBg),
            child: Column(
              children: [
                // Brand Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.emeraldGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.fingerprint,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FENSI Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'HC Web Portal',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 16),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          selected: isSelected,
                          selectedTileColor: selectedTileColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          leading: Icon(
                            item['icon'],
                            color: isSelected ? Colors.white : Colors.white60,
                            size: 20,
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Logout Button
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.logout,
                      color: AppTheme.roseDanger, size: 20),
                  title: const Text('Keluar (Logout)',
                      style: TextStyle(
                          color: AppTheme.roseDanger, fontSize: 14)),
                  onTap: _confirmLogout,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── Main Content ────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: headerBg,
                    border: Border(
                        bottom: BorderSide(color: headerBorder)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _menuItems[_selectedIndex]['title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.slateGray,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primaryNavy,
                            child: Text(
                              profile?.fullName.substring(0, 1) ?? 'A',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.fullName ?? 'Admin HC',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark
                                      ? AppTheme.darkTextPrimary
                                      : AppTheme.slateGray,
                                ),
                              ),
                              Text(
                                'Human Capital Admin',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppTheme.darkTextMuted
                                      : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dynamic Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: _views[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
