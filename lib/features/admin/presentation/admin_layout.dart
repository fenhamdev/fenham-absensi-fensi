import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/logout_service.dart';
import '../../../core/widgets/responsive.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Widget _buildSidebarContent(BuildContext context, {required bool isDrawer}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg = isDark ? AppTheme.darkSurface : AppTheme.slateGray;
    final selectedTileColor =
        isDark ? AppTheme.darkNavy : AppTheme.primaryNavy;

    return Container(
      color: sidebarBg,
      child: Column(
        children: [
          // Brand Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'FENSI Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'HC Web Portal',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      if (isDrawer) {
                        Navigator.pop(context);
                      }
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
                style: TextStyle(color: AppTheme.roseDanger, fontSize: 14)),
            onTap: () {
              if (isDrawer) {
                Navigator.pop(context);
              }
              _confirmLogout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final headerBg = isDark ? AppTheme.darkCard : Colors.white;
    final headerBorder = isDark ? AppTheme.darkBorder : AppTheme.neutralBorder;

    final double padding = isMobile ? 14.0 : (isDesktop ? 28.0 : 20.0);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.softBackground,
      drawer: !isDesktop
          ? Drawer(
              child: _buildSidebarContent(context, isDrawer: true),
            )
          : null,
      body: Row(
        children: [
          // Permanent Sidebar Navigation for Desktop
          if (isDesktop)
            SizedBox(
              width: 260,
              child: _buildSidebarContent(context, isDrawer: false),
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 64,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
                  decoration: BoxDecoration(
                    color: headerBg,
                    border: Border(bottom: BorderSide(color: headerBorder)),
                  ),
                  child: Row(
                    children: [
                      if (!isDesktop) ...[
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.slateGray,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _menuItems[_selectedIndex]['title'],
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.slateGray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primaryNavy,
                            child: Text(
                              profile?.fullName.substring(0, 1) ?? 'A',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                          if (!isMobile) ...[
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
                        ],
                      ),
                    ],
                  ),
                ),

                // Dynamic Body
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
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

