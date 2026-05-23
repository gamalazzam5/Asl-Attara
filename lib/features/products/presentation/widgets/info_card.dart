
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

Widget infoCard(
    BuildContext context, {

      required String title,
      required String value,
      required IconData icon,
    }) {
  return Container(
    width: (MediaQuery.of(context).size.width - 64.w) / 2,

    padding: EdgeInsets.all(16.r),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(18.r),
    ),

    child: Column(
      children: [
        Icon(icon, color: AppColors.primaryColor),

        SizedBox(height: 8.h),

        Text(title),

        SizedBox(height: 8.h),

        Text(
          value,

          style: TextStyles.text16.copyWith(
            fontWeight: FontWeight.bold,

            color: AppColors.primaryColor,
          ),
        ),
      ],
    ),
  );
}

