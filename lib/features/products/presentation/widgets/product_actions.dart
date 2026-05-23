import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          width: double.infinity,
          onTap: () {},

          text: 'تعديل المنتج',

          backgroundColor: AppColors.primaryColor,

          icon: Icons.edit_outlined,
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: CustomButton(
                onTap: () {},

                text: 'سجل العمليات',

                backgroundColor: Colors.white,

                textColor: Colors.black,

                icon: Icons.history,
                iconColor: Colors.black,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: CustomButton(
                onTap: () {},

                text: 'حذف',

                backgroundColor: Colors.red,

                icon: Icons.delete_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
