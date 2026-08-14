import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, success, danger, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 48,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppTheme.primaryNavy;
      case ButtonVariant.success:
        return AppTheme.emeraldGreen;
      case ButtonVariant.danger:
        return AppTheme.roseDanger;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (variant == ButtonVariant.outline) {
      return AppTheme.slateGray;
    }
    return Colors.white;
  }

  BorderSide _getBorder() {
    if (variant == ButtonVariant.outline) {
      return const BorderSide(color: AppTheme.neutralBorder, width: 1.5);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getTextColor(),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _getBorder(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
