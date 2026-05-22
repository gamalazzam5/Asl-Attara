import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isAlert;
  final IconData? icon;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    this.isAlert = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isAlert ? AppColors.errorColor : AppColors.primaryColor;
    final backgroundColor = isAlert ? Colors.red.shade50 : Colors.white;

    return Container(
      height: 140.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.text14.copyWith(
                    color: isAlert ? AppColors.errorColor : AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyles.text24.copyWith(
              fontWeight: FontWeight.bold,
              color: isAlert ? AppColors.errorColor :AppColors.primaryColor,
              fontSize: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
}
