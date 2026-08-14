import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/status_badge.dart';
import '../../auth/presentation/login_screen.dart';
import '../models/leave_model.dart';

class LeaveSubmissionScreen extends ConsumerStatefulWidget {
  const LeaveSubmissionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaveSubmissionScreen> createState() => _LeaveSubmissionScreenState();
}

class _LeaveSubmissionScreenState extends ConsumerState<LeaveSubmissionScreen> {
  final _reasonController = TextEditingController();
  String _selectedType = 'Cuti Tahunan';
  DateTime _startDate = DateTime.now().add(const Duration(days: 2));
  DateTime _endDate = DateTime.now().add(const Duration(days: 3));
  String? _attachmentName;
  bool _isSubmitting = false;

  final List<LeaveModel> _leaveHistory = [
    LeaveModel(
      id: 'L-001',
      userId: 'emp-456',
      userName: 'Ahmad Fauzi',
      type: 'Cuti Tahunan',
      startDate: DateTime(2026, 7, 10),
      endDate: DateTime(2026, 7, 12),
      reason: 'Acara Keluarga di Bandung',
      status: 'Approved',
      adminNotes: 'Disetujui. Kuota cuti terpotong 3 hari.',
    ),
    LeaveModel(
      id: 'L-002',
      userId: 'emp-456',
      userName: 'Ahmad Fauzi',
      type: 'Izin Sakit',
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 1),
      reason: 'Demam & Flu Berat',
      attachmentUrl: 'surat_dokter.pdf',
      status: 'Approved',
    ),
  ];

  int get _calculatedDays {
    return _endDate.difference(_startDate).inDays + 1;
  }

  void _submitLeaveForm() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi alasan pengajuan cuti/izin.'),
          backgroundColor: AppTheme.roseDanger,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final profile = ref.read(currentProfileProvider);

    final newLeave = LeaveModel(
      id: 'L-00${_leaveHistory.length + 1}',
      userId: profile?.id ?? 'emp-456',
      userName: profile?.fullName ?? 'Ahmad Fauzi',
      type: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      reason: _reasonController.text,
      attachmentUrl: _attachmentName,
      status: 'Pending',
    );

    setState(() {
      _leaveHistory.insert(0, newLeave);
      _isSubmitting = false;
      _reasonController.clear();
      _attachmentName = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengajuan berhasil dikirim ke Admin/HC.'),
          backgroundColor: AppTheme.emeraldGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final quota = profile?.quotaCuti ?? 12;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kuota Cuti Card
          CustomCard(
            backgroundColor: AppTheme.primaryNavy,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event_available, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sisa Kuota Cuti Tahunan',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$quota Hari Tersedia',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form Pengajuan
          const Text(
            'Form Pengajuan Cuti / Izin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipe Cuti Dropdown
                const Text('Jenis Pengajuan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.neutralBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      items: ['Cuti Tahunan', 'Izin Sakit', 'Izin Khusus'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Range Tanggal
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Mulai', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2027),
                              );
                              if (picked != null) {
                                setState(() {
                                  _startDate = picked;
                                  if (_endDate.isBefore(_startDate)) _endDate = _startDate;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.neutralBorder),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryNavy),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('dd/MM/yyyy').format(_startDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Selesai', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: _startDate,
                                lastDate: DateTime(2027),
                              );
                              if (picked != null) {
                                setState(() => _endDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.neutralBorder),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryNavy),
                                  const SizedBox(width: 8),
                                  Text(DateFormat('dd/MM/yyyy').format(_endDate)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total durasi: $_calculatedDays hari kerja',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Alasan / Keterangan',
                  hint: 'Tuliskan alasan lengkap...',
                  controller: _reasonController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Upload Lampiran / Surat Dokter
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.attach_file, size: 18),
                  label: Text(_attachmentName ?? 'Upload Surat Dokter / Lampiran (Opsional)'),
                  onPressed: () {
                    setState(() {
                      _attachmentName = 'dokumen_lampiran_${DateTime.now().millisecondsSinceEpoch}.pdf';
                    });
                  },
                ),
                const SizedBox(height: 20),

                CustomButton(
                  text: 'Kirim Pengajuan',
                  isLoading: _isSubmitting,
                  onPressed: _submitLeaveForm,
                  icon: Icons.send_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Status & History Tracking
          const Text(
            'Riwayat Pengajuan Cuti',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _leaveHistory.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final leave = _leaveHistory[index];
              return CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          leave.type,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        StatusBadge(status: leave.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${DateFormat('dd MMM').format(leave.startDate)} - ${DateFormat('dd MMM yyyy').format(leave.endDate)} (${leave.durationDays} hari)',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text('Alasan: ${leave.reason}', style: const TextStyle(fontSize: 13)),
                    if (leave.adminNotes != null) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.softBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Catatan HC: ${leave.adminNotes}',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
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
