import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EmployeeManagementView extends StatefulWidget {
  const EmployeeManagementView({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementView> createState() => _EmployeeManagementViewState();
}

class _EmployeeManagementViewState extends State<EmployeeManagementView> {
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 'EMP-001',
      'name': 'Ahmad Fauzi',
      'email': 'ahmad.fauzi@fenham.com',
      'role': 'Karyawan',
      'department': 'Engineering',
      'quota': 12,
      'status': 'Aktif',
    },
    {
      'id': 'EMP-002',
      'name': 'Siti Nurhaliza',
      'email': 'siti.nurhaliza@fenham.com',
      'role': 'Karyawan',
      'department': 'Human Capital',
      'quota': 10,
      'status': 'Aktif',
    },
    {
      'id': 'EMP-003',
      'name': 'Budi Santoso',
      'email': 'budi.santoso@fenham.com',
      'role': 'Admin HC',
      'department': 'Human Capital',
      'quota': 12,
      'status': 'Aktif',
    },
    {
      'id': 'EMP-004',
      'name': 'Rian Hidayat',
      'email': 'rian.hidayat@fenham.com',
      'role': 'Karyawan',
      'department': 'Finance',
      'quota': 8,
      'status': 'Aktif',
    },
  ];

  void _showAddEmployeeDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final deptCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Karyawan Baru'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(label: 'Nama Lengkap', hint: 'Budi Raharjo', controller: nameCtrl),
              const SizedBox(height: 12),
              CustomTextField(label: 'Email Perusahaan', hint: 'budi@fenham.com', controller: emailCtrl),
              const SizedBox(height: 12),
              CustomTextField(label: 'Departemen', hint: 'Software Engineering', controller: deptCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _employees.add({
                    'id': 'EMP-00${_employees.length + 1}',
                    'name': nameCtrl.text,
                    'email': emailCtrl.text,
                    'role': 'Karyawan',
                    'department': deptCtrl.text.isEmpty ? 'General' : deptCtrl.text,
                    'quota': 12,
                    'status': 'Aktif',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Karyawan berhasil ditambahkan!'), backgroundColor: AppTheme.emeraldGreen),
                );
              }
            },
            child: const Text('Simpan Data', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Manajemen Data Karyawan (CRUD)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                  ),
                  Text(
                    'Kelola profil, departemen, sisa kuota cuti, dan reset password karyawan',
                    style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  ),
                ],
              ),
              CustomButton(
                text: 'Tambah Karyawan',
                icon: Icons.person_add,
                onPressed: _showAddEmployeeDialog,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID Karyawan')),
                  DataColumn(label: Text('Nama Karyawan')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Departemen')),
                  DataColumn(label: Text('Quota Cuti')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _employees.map((emp) {
                  return DataRow(cells: [
                    DataCell(Text(emp['id'])),
                    DataCell(Text(emp['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(emp['email'])),
                    DataCell(Text(emp['department'])),
                    DataCell(Text('${emp['quota']} Hari')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: emp['status'] == 'Aktif' ? AppTheme.emeraldLight : AppTheme.roseLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          emp['status'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: emp['status'] == 'Aktif' ? AppTheme.emeraldGreen : AppTheme.roseDanger,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryNavy, size: 20),
                            onPressed: () {},
                            tooltip: 'Edit Profile',
                          ),
                          IconButton(
                            icon: const Icon(Icons.lock_reset, color: AppTheme.amberWarning, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Link reset password dikirim ke ${emp['email']}')),
                              );
                            },
                            tooltip: 'Reset Password',
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
