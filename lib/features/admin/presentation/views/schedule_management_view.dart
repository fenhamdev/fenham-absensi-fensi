import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_card.dart';

class ScheduleManagementView extends StatelessWidget {
  const ScheduleManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manajemen Jadwal Shift Karyawan (HC View)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const Text(
            'Kalender kerja mingguan / bulanan per divisi atau per individu karyawan',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Matriks Jadwal Kerja - Agustus 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    DropdownButton<String>(
                      value: 'All Departments',
                      items: ['All Departments', 'Engineering', 'Human Capital', 'Finance'].map((d) {
                        return DropdownMenuItem(value: d, child: Text(d));
                      }).toList(),
                      onChanged: (val) {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nama Karyawan')),
                      DataColumn(label: Text('Senin (10/8)')),
                      DataColumn(label: Text('Selasa (11/8)')),
                      DataColumn(label: Text('Rabu (12/8)')),
                      DataColumn(label: Text('Kamis (13/8)')),
                      DataColumn(label: Text('Jumat (14/8)')),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text('Ahmad Fauzi')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Siti Nurhaliza')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Dewi Lestari')),
                        DataCell(Text('Cuti')),
                        DataCell(Text('Cuti')),
                        DataCell(Text('Cuti')),
                        DataCell(Text('08:00 - 17:00')),
                        DataCell(Text('08:00 - 17:00')),
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
}
