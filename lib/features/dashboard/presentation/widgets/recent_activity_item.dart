import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

import 'recent_activity_process.dart';

class RecentActivityItem extends StatelessWidget {
  const RecentActivityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              'آخر العمليات',

              style: TextStyles.text18.copyWith(
                color: AppColors.primaryColor,

                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              'عرض الكل',

              style: TextStyles.text14.copyWith(color: AppColors.primaryColor),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        ListView.builder(
          itemCount: 3,

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemBuilder: (_, index) {
            return const RecentActivityProcess();
          },
        ),
      ],
    );
  }
}
