import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

class QuantityCard extends StatelessWidget {
  final double quantity;
  final String unit;

  const QuantityCard({super.key, required this.unit, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(20.r),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18.r),
      ),

      child: Column(
        children: [
          Text('الكمية المتوفرة', style: TextStyles.text16),

          SizedBox(height: 10.h),

          Text(
            '$quantity',

            style: TextStyles.text24.copyWith(
              fontWeight: FontWeight.bold,

              color: AppColors.primaryColor,
            ),
          ),

          Text(unit, style: TextStyles.text16),
        ],
      ),
    );
  }
}
