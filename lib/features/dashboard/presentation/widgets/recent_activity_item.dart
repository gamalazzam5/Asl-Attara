import 'package:aslattara/features/dashboard/presentation/widgets/recent_activity_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

class RecentActivityItem extends StatelessWidget {
  const RecentActivityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Row(
          mainAxisAlignment: .spaceBetween,
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
              style: TextStyles.text14.copyWith(
                color: AppColors.primaryColor,
              ),
            )
          ],
        ),

        SizedBox(height: 12.h),

        Flexible(
          child: ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return RecentActivityProcess();
            },
          ),
        )
      ],
    );
  }
}