import 'package:aslattara/core/constants/app_colors.dart';
import 'package:aslattara/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Text(
          "أصل العطارة",
          style: TextStyles.text24.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 16.h),

        Text(
          "مرحباً بعودتك!",
          style: TextStyles.text22.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4.h),

        Text(
          "إليك نظرة عامة على متجرك اليوم.",
          style: TextStyles.text14.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}