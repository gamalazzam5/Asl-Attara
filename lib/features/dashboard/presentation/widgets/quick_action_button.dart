import 'package:aslattara/core/constants/app_colors.dart';
import 'package:aslattara/core/constants/text_style.dart';
import 'package:aslattara/core/routes/route_names.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/manger/cubits/category_state.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,

          child: Text(
            'العمليات السريعة',

            style: TextStyles.text18.copyWith(
              fontWeight: FontWeight.w600,

              color: AppColors.primaryColor,
            ),
          ),
        ),

        SizedBox(height: 12.h),

        InkWell(
          borderRadius: BorderRadius.circular(16.r),

          onTap: () async {
            final categoryCubit = context.read<CategoryCubit>();
            var categoryState = categoryCubit.state;

            if (categoryState is! CategoryLoaded) {
              await categoryCubit.loadCategories();
              categoryState = categoryCubit.state;
            }

            if (!context.mounted) return;

            if (categoryState is CategoryLoaded &&
                categoryState.categories.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('أضف قسم أولاً قبل إضافة منتج')),
              );
              return;
            }

            context.push(RouteNames.addProduct);
          },

          child: Container(
            height: 70.h,

            width: double.infinity,

            decoration: BoxDecoration(
              color: AppColors.primaryColor,

              borderRadius: BorderRadius.circular(16.r),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.add_circle_outline,

                  color: Colors.white,

                  size: 22.sp,
                ),

                SizedBox(width: 10.w),

                Text(
                  'إضافة منتج',

                  style: TextStyles.text16.copyWith(
                    color: Colors.white,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
