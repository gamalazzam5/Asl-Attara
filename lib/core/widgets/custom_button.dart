import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/text_style.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color backgroundColor;
  final IconData? icon;
  final Color textColor;
  final Color iconColor;
  final double borderRadius;
  final double verticalPadding;
  final double? width;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.backgroundColor,
    this.icon,

    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.borderRadius = 12,
    this.verticalPadding = 16,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,

      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: verticalPadding.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 22.r),
              SizedBox(width: 8.w),
            ],
            Text(text, style: TextStyles.text18.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
