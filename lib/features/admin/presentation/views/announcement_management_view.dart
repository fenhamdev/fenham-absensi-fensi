import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';

class AnnouncementManagementView extends StatefulWidget {
  const AnnouncementManagementView({Key? key}) : super(key: key);

  @override
  State<AnnouncementManagementView> createState() => _AnnouncementManagementViewState();
}

class _AnnouncementManagementViewState extends State<AnnouncementManagementView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPublishing = false;

  void _publishAnnouncement() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi judul dan konten pengumuman.'), backgroundColor: AppTheme.roseDanger),
      );
      return;
    }

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isPublishing = false;
      _titleController.clear();
      _contentController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengumuman resmi berhasil dipublikasikan ke seluruh karyawan!'), backgroundColor: AppTheme.emeraldGreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kelola & Publikasikan Pengumuman',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const Text(
            'Kirimkan broadcast pemberitahuan ke aplikasi mobile karyawan',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Buat Pengumuman Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Judul Pengumuman',
                  hint: 'Misal: Jadwal Libur / Townhall Meeting',
                  controller: _titleController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Isi Broadcast / Konten',
                  hint: 'Tuliskan pengumuman secara rinci...',
                  controller: _contentController,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Publikasikan Sekarang',
                  icon: Icons.campaign_rounded,
                  isLoading: _isPublishing,
                  onPressed: _publishAnnouncement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
