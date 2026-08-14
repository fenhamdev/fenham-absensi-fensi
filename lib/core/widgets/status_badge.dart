import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'hadir':
      case 'approved':
      case 'tepat waktu':
        return AppTheme.emeraldLight;
      case 'terlambat':
      case 'pending':
        return AppTheme.amberLight;
      case 'rejected':
      case 'absen':
        return AppTheme.roseLight;
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getTextColor() {
    switch (status.toLowerCase()) {
      case 'hadir':
      case 'approved':
      case 'tepat waktu':
        return AppTheme.emeraldGreen;
      case 'terlambat':
      case 'pending':
        return AppTheme.amberWarning;
      case 'rejected':
      case 'absen':
        return AppTheme.roseDanger;
      default:
        return AppTheme.slateGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
