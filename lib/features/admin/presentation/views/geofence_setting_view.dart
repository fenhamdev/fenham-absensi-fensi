import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_text_field.dart';

class GeofenceSettingView extends StatefulWidget {
  const GeofenceSettingView({Key? key}) : super(key: key);

  @override
  State<GeofenceSettingView> createState() => _GeofenceSettingViewState();
}

class _GeofenceSettingViewState extends State<GeofenceSettingView> {
  final _nameCtrl = TextEditingController(text: 'PT. Fenham Indonesia Utama');
  final _addressCtrl = TextEditingController(text: 'Jl. Jend. Sudirman No. 45, Jakarta Pusat');
  final _latCtrl = TextEditingController(text: '-6.208800');
  final _lngCtrl = TextEditingController(text: '106.845600');
  final _radiusCtrl = TextEditingController(text: '150');
  bool _isSaving = false;

  void _saveGeofenceSettings() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengaturan koordinat & geofence kantor berhasil diperbarui!'),
          backgroundColor: AppTheme.emeraldGreen,
        ),
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
            'Pengaturan Geofence & Lokasi Kantor Utama',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.slateGray),
          ),
          const Text(
            'Atur titik pusat koordinat GPS kantor serta batas maksimal radius (meter) untuk absensi',
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(label: 'Nama PT / Gedung', controller: _nameCtrl),
                const SizedBox(height: 16),
                CustomTextField(label: 'Alamat Lengkap', controller: _addressCtrl, maxLines: 2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: CustomTextField(label: 'Latitude Kantor', controller: _latCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: CustomTextField(label: 'Longitude Kantor', controller: _lngCtrl)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Toleransi Radius Geofence (Meter)',
                  hint: '150',
                  controller: _radiusCtrl,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Simpan Konfigurasi Lokasi',
                  icon: Icons.save_rounded,
                  isLoading: _isSaving,
                  onPressed: _saveGeofenceSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
