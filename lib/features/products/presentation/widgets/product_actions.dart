import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_button.dart';

import '../../domain/entities/product_entity.dart';

class ProductActions extends StatelessWidget {
  final ProductEntity product;

  const ProductActions({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          width: double.infinity,

          onTap: () {
            context.push(RouteNames.editProduct, extra: product);
          },

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
