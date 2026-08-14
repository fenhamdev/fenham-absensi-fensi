import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_card.dart';

class AnnouncementBoardScreen extends StatelessWidget {
  const AnnouncementBoardScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> announcements = const [
    {
      'title': 'Jadwal Libur Nasional & Cuti Bersama 17 Agustus',
      'date': '14 Agustus 2026',
      'category': 'Pengumuman Resmi',
      'content': 'Diberitahukan kepada seluruh karyawan PT Fenham Indonesia bahwa operasional kantor akan diliburkan pada tanggal 17 Agustus 2026 dalam rangka Hari Kemerdekaan RI.',
    },
    {
      'title': 'Pembaruan Fitur Geofencing Absensi FENSI 2.0',
      'date': '10 Agustus 2026',
      'category': 'Sistem & IT',
      'content': 'Sistem absensi kini mendukung pembaruan koordinat GPS realtime dengan radius toleransi 150 meter dari gedung utama. Mohon pastikan GPS perangkat Anda selalu Aktif.',
    },
    {
      'title': 'Townhall Meeting Kuartal III - 2026',
      'date': '01 Agustus 2026',
      'category': 'Kegiatan Internal',
      'content': 'Seluruh jajaran tim diharapkan hadir dalam Townhall Meeting Q3 yang akan dilaksanakan secara Hybrid pada hari Jumat mendatang.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Papan Pengumuman Perusahaan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const Text(
            'Informasi penting & kabar terbaru dari HC / Management',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: announcements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = announcements[index];
              return CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.softBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['category']!,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                          ),
                        ),
                        Text(
                          item['date']!,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['content']!,
                      style: const TextStyle(fontSize: 14, color: AppTheme.slateGray, height: 1.4),
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
