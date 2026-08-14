import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/status_badge.dart';

class LeaveApprovalView extends StatefulWidget {
  const LeaveApprovalView({Key? key}) : super(key: key);

  @override
  State<LeaveApprovalView> createState() => _LeaveApprovalViewState();
}

class _LeaveApprovalViewState extends State<LeaveApprovalView> {
  final List<Map<String, dynamic>> _pendingLeaves = [
    {
      'id': 'L-003',
      'name': 'Dewi Lestari',
      'department': 'Marketing',
      'type': 'Cuti Tahunan',
      'dates': '18 Agu - 20 Agu 2026 (3 Hari)',
      'reason': 'Liburan Keluarga pasca Proyek Q2',
      'attachment': null,
      'status': 'Pending',
    },
    {
      'id': 'L-004',
      'name': 'Rian Hidayat',
      'department': 'Finance',
      'type': 'Izin Sakit',
      'dates': '15 Agu 2026 (1 Hari)',
      'reason': 'Pemeriksaan Rutin Dokter Spesialis',
      'attachment': 'surat_dokter_rian.pdf',
      'status': 'Pending',
    },
  ];

  void _handleApproval(int index, bool isApproved) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isApproved ? 'Setujui Pengajuan Cuti' : 'Tolak Pengajuan Cuti'),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(
            labelText: 'Catatan Admin / HC (Opsional)',
            hintText: 'Misal: Selamat berlibur / Pekerjaan dicover tim...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isApproved ? AppTheme.emeraldGreen : AppTheme.roseDanger,
            ),
            onPressed: () {
              setState(() {
                _pendingLeaves[index]['status'] = isApproved ? 'Approved' : 'Rejected';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isApproved ? 'Pengajuan disetujui!' : 'Pengajuan ditolak.'),
                  backgroundColor: isApproved ? AppTheme.emeraldGreen : AppTheme.roseDanger,
                ),
              );
            },
            child: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
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
          const Text(
            'Persetujuan Cuti & Izin Karyawan (Approval HC)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const Text(
            'Tinjau permohonan cuti tahunan, izin sakit, serta verifikasi surat dokter',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pendingLeaves.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final leave = _pendingLeaves[index];
              return CustomCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryNavy,
                      child: Text(
                        leave['name'].substring(0, 1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(leave['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text('• ${leave['department']}', style: const TextStyle(color: AppTheme.textMuted)),
                              const Spacer(),
                              StatusBadge(status: leave['status']),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Tipe: ${leave['type']} | Tanggal: ${leave['dates']}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryNavy)),
                          const SizedBox(height: 4),
                          Text('Alasan: ${leave['reason']}', style: const TextStyle(fontSize: 13)),
                          if (leave['attachment'] != null) ...[
                            const SizedBox(height: 8),
                            Chip(
                              avatar: const Icon(Icons.picture_as_pdf, size: 16, color: AppTheme.roseDanger),
                              label: Text('Lampiran: ${leave['attachment']}'),
                            ),
                          ],
                          const SizedBox(height: 12),
                          if (leave['status'] == 'Pending')
                            Row(
                              children: [
                                CustomButton(
                                  text: 'Setujui (Approve)',
                                  variant: ButtonVariant.success,
                                  height: 38,
                                  icon: Icons.check,
                                  onPressed: () => _handleApproval(index, true),
                                ),
                                const SizedBox(width: 10),
                                CustomButton(
                                  text: 'Tolak (Reject)',
                                  variant: ButtonVariant.danger,
                                  height: 38,
                                  icon: Icons.close,
                                  onPressed: () => _handleApproval(index, false),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
