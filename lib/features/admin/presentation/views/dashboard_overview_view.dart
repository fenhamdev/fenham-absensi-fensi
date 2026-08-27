import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_badge.dart';

class DashboardOverviewView extends StatelessWidget {
  const DashboardOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Summary Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              final isMobile = constraints.maxWidth < 550;
              return GridView.count(
                crossAxisCount: isDesktop ? 4 : (isMobile ? 1 : 2),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                childAspectRatio: isDesktop ? 1.8 : (isMobile ? 2.6 : 1.6),
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _StatCard(
                    title: 'Total Karyawan',
                    value: '148 Orang',
                    icon: Icons.people_alt_outlined,
                    color: AppTheme.primaryNavy,
                  ),
                  _StatCard(
                    title: 'Hadir Hari Ini',
                    value: '132 Orang',
                    icon: Icons.check_circle_outline,
                    color: AppTheme.emeraldGreen,
                  ),
                  _StatCard(
                    title: 'Terlambat / Absen',
                    value: '11 Orang',
                    icon: Icons.access_time_filled,
                    color: AppTheme.amberWarning,
                  ),
                  _StatCard(
                    title: 'Pengajuan Cuti Pending',
                    value: '5 Pengajuan',
                    icon: Icons.assignment_outlined,
                    color: AppTheme.roseDanger,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Visual Analytics Charts Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;
              return isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildAttendanceBarChart()),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildStatusPieChart()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildAttendanceBarChart(),
                        const SizedBox(height: 16),
                        _buildStatusPieChart(),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),

          // Recent Attendances Live Log Table
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 480;
                    return isSmall
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Log Absensi Karyawan Hari Ini (Realtime)',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.file_download, size: 18),
                                  label: const Text('Ekspor Laporan'),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Laporan absensi berhasil diekspor ke Excel & PDF.'),
                                        backgroundColor: AppTheme.emeraldGreen,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Log Absensi Karyawan Hari Ini (Realtime)',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.file_download, size: 18),
                                label: const Text('Ekspor Laporan'),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Laporan absensi berhasil diekspor ke Excel & PDF.'),
                                      backgroundColor: AppTheme.emeraldGreen,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nama Karyawan')),
                      DataColumn(label: Text('Departemen')),
                      DataColumn(label: Text('Jam Masuk')),
                      DataColumn(label: Text('Jam Keluar')),
                      DataColumn(label: Text('Jarak Geofence')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('Ahmad Fauzi')),
                        DataCell(Text('Engineering')),
                        DataCell(Text('07:54 WIB')),
                        DataCell(Text('17:02 WIB')),
                        DataCell(Text('42.5 meter')),
                        DataCell(StatusBadge(status: 'Hadir')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Siti Nurhaliza')),
                        DataCell(Text('Human Capital')),
                        DataCell(Text('08:12 WIB')),
                        DataCell(Text('--:--')),
                        DataCell(Text('18.2 meter')),
                        DataCell(StatusBadge(status: 'Terlambat')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Rian Hidayat')),
                        DataCell(Text('Finance')),
                        DataCell(Text('07:48 WIB')),
                        DataCell(Text('17:00 WIB')),
                        DataCell(Text('65.0 meter')),
                        DataCell(StatusBadge(status: 'Hadir')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Dewi Lestari')),
                        DataCell(Text('Marketing')),
                        DataCell(Text('--:--')),
                        DataCell(Text('--:--')),
                        DataCell(Text('0 meter')),
                        DataCell(StatusBadge(status: 'Cuti')),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBarChart() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Kehadiran Mingguan (Senin - Jumat)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 160,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBarGroup(0, 140, 6),
                  _makeBarGroup(1, 142, 4),
                  _makeBarGroup(2, 138, 8),
                  _makeBarGroup(3, 145, 2),
                  _makeBarGroup(4, 132, 11),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: AppTheme.primaryNavy, width: 14, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: y2, color: AppTheme.amberWarning, width: 14, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildStatusPieChart() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Status Hari Ini',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(color: AppTheme.emeraldGreen, value: 85, title: '85%\nHadir', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  PieChartSectionData(color: AppTheme.amberWarning, value: 8, title: '8%\nLate', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  PieChartSectionData(color: AppTheme.roseDanger, value: 4, title: '4%\nAbsen', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  PieChartSectionData(color: AppTheme.primaryNavy, value: 3, title: '3%\nCuti', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.slateGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
