import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/services/logout_service.dart';
import '../../auth/presentation/login_screen.dart';
import '../../leave/presentation/leave_submission_screen.dart';
import '../../announcement/presentation/announcement_board_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../services/location_service.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  int _currentBottomNavIndex = 0;
  bool _isClockedIn = false;
  String? _clockInTimeString;
  String? _clockOutTimeString;

  // Office Location (FENHAM - Toko Oleh-Oleh Haji Umroh Jogja)
  final double officeLat = -7.7542585;
  final double officeLng = 110.3762106;
  final double allowedRadiusMeters = 150.0;

  // Current Position State
  double _currentLat = -7.7542;
  double _currentLng = 110.3761;
  double _distanceToOfficeMeters = 42.5;
  bool _isWithinGeofence = true;
  bool _isLoadingLocation = false;

  late Timer _timer;
  String _currentTimeString = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateClock();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateClock());
    _fetchLiveLocation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    setState(() {
      _currentTimeString = DateFormat('HH:mm:ss').format(now);
    });
  }

  Future<void> _fetchLiveLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final pos = await LocationService.getCurrentLocation();
      final dist = LocationService.calculateDistanceInMeters(
        pos.latitude,
        pos.longitude,
        officeLat,
        officeLng,
      );
      final isInside = dist <= allowedRadiusMeters;

      if (mounted) {
        setState(() {
          _currentLat = pos.latitude;
          _currentLng = pos.longitude;
          _distanceToOfficeMeters = dist;
          _isWithinGeofence = isInside;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      // Fallback demo distance if permission or location unavailable
      if (mounted) {
        setState(() {
          _distanceToOfficeMeters = LocationService.calculateDistanceInMeters(
            _currentLat,
            _currentLng,
            officeLat,
            officeLng,
          );
          _isWithinGeofence = _distanceToOfficeMeters <= allowedRadiusMeters;
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _handleClockAction(bool isClockIn) {
    if (!_isWithinGeofence) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal! Anda berada di luar radius kantor (${_distanceToOfficeMeters.toStringAsFixed(1)}m dari batas ${allowedRadiusMeters.toInt()}m).',
          ),
          backgroundColor: AppTheme.roseDanger,
        ),
      );
      return;
    }

    final nowStr = DateFormat('HH:mm:ss').format(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isClockIn ? 'Konfirmasi Absensi Masuk' : 'Konfirmasi Absensi Keluar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jam: $nowStr WIB'),
            const SizedBox(height: 8),
            Text('Jarak Kantor: ${_distanceToOfficeMeters.toStringAsFixed(1)} meter'),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan/Keterangan (Opsional)',
                hintText: 'Misal: Bekerja di lantai 3...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isClockIn ? AppTheme.emeraldGreen : AppTheme.primaryNavy,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (isClockIn) {
                  _isClockedIn = true;
                  _clockInTimeString = nowStr;
                } else {
                  _isClockedIn = false;
                  _clockOutTimeString = nowStr;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isClockIn ? 'Berhasil Absensi Masuk pada $nowStr' : 'Berhasil Absensi Keluar pada $nowStr',
                  ),
                  backgroundColor: AppTheme.emeraldGreen,
                ),
              );
            },
            child: const Text('Kirim Presensi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceView() {
    final profile = ref.watch(currentProfileProvider);
    final todayStr = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Greeting Header
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.primaryNavy,
                child: Text(
                  profile?.fullName.substring(0, 1) ?? 'K',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${profile?.fullName ?? 'Karyawan'} 👋',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                    ),
                    Text(
                      '${profile?.department ?? 'General'} • NIK: 2026-0814',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Live Clock & Date Card
          CustomCard(
            backgroundColor: AppTheme.slateGray,
            child: Column(
              children: [
                Text(
                  todayStr.toUpperCase(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentTimeString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      'Jam Kerja Standard: 08:00 - 17:00 WIB',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // GPS & Geofencing Location Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on_rounded, color: AppTheme.primaryNavy, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Geofence Lokasi Kantor',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.slateGray),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20, color: AppTheme.textMuted),
                      onPressed: _fetchLiveLocation,
                      tooltip: 'Perbarui Lokasi GPS',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isWithinGeofence ? AppTheme.emeraldLight : AppTheme.roseLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isWithinGeofence ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: _isWithinGeofence ? AppTheme.emeraldGreen : AppTheme.roseDanger,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isWithinGeofence
                                  ? 'Di Dalam Radius Kantor'
                                  : 'Di Luar Radius Kantor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isWithinGeofence ? AppTheme.emeraldGreen : AppTheme.roseDanger,
                              ),
                            ),
                            Text(
                              'Jarak dari kantor: ${_distanceToOfficeMeters.toStringAsFixed(1)}m (Max: ${allowedRadiusMeters.toInt()}m)',
                              style: const TextStyle(fontSize: 12, color: AppTheme.slateGray),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Koordinat Saya: ${_currentLat.toStringAsFixed(6)}, ${_currentLng.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Presensi Masuk & Keluar Action Section
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: Column(
                    children: [
                      const Icon(Icons.login_rounded, color: AppTheme.emeraldGreen, size: 32),
                      const SizedBox(height: 8),
                      const Text(
                        'Masuk',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      Text(
                        _clockInTimeString ?? '--:--',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Clock In',
                        variant: ButtonVariant.success,
                        onPressed: _isClockedIn ? null : () => _handleClockAction(true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCard(
                  child: Column(
                    children: [
                      const Icon(Icons.logout_rounded, color: AppTheme.primaryNavy, size: 32),
                      const SizedBox(height: 8),
                      const Text(
                        'Keluar',
                        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                      Text(
                        _clockOutTimeString ?? '--:--',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Clock Out',
                        variant: ButtonVariant.primary,
                        onPressed: !_isClockedIn ? null : () => _handleClockAction(false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Riwayat Presensi Singkat
          const Text(
            'Riwayat Absensi Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const SizedBox(height: 12),
          CustomCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, size: 20, color: AppTheme.primaryNavy),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kemarin (13 Agu 2026)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('07:54 - 17:05 WIB', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                StatusBadge(status: 'Hadir'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppTheme.darkSurface : Colors.white;
    final navBorder = isDark ? AppTheme.darkBorder : AppTheme.neutralBorder;
    final selectedColor = isDark ? AppTheme.darkNavy : AppTheme.primaryNavy;
    final unselectedColor = isDark ? AppTheme.darkTextMuted : AppTheme.textMuted;

    final List<Widget> pages = [
      _buildAttendanceView(),
      const LeaveSubmissionScreen(),
      const AnnouncementBoardScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.fingerprint,
                color: isDark ? AppTheme.darkNavy : AppTheme.primaryNavy,
                size: 24),
            const SizedBox(width: 8),
            const Text('FENSI Mobile'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.roseDanger),
            tooltip: 'Logout',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text(
                      'Apakah Anda yakin ingin keluar?\nAnda akan diminta login kembali saat membuka aplikasi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.roseDanger),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Keluar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
              if (confirmed == true && mounted) {
                await performLogout(context, ref);
              }
            },
          )
        ],
      ),
      body: pages[_currentBottomNavIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: navBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: navBg,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint),
              label: 'Presensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              label: 'Cuti & Izin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              label: 'Pengumuman',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
