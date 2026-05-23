import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,

          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,

              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),

            onPressed: () {},

            icon: const Icon(Icons.edit),

            label: const Text('تعديل المنتج'),
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},

                child: const Text('سجل العمليات'),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () {},

                child: const Text('حذف'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
