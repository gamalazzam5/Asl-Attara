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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                label: 'إضافة منتج',
                icon: Icons.add_circle_outline,
                onTap: () => _goToAddProduct(context),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _QuickActionCard(
                label: 'بيع منتج',
                icon: Icons.point_of_sale,
                onTap: () => context.push(RouteNames.sellProduct),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _QuickActionCard(
          label: 'جرد المخزون',
          icon: Icons.fact_check_outlined,
          compact: true,
          onTap: () => context.push(RouteNames.inventoryAudit),
        ),
      ],
    );
  }

  Future<void> _goToAddProduct(BuildContext context) async {
    final categoryCubit = context.read<CategoryCubit>();
    var categoryState = categoryCubit.state;

    if (categoryState is! CategoryLoaded) {
      await categoryCubit.loadCategories();
      categoryState = categoryCubit.state;
    }

    if (!context.mounted) return;

    if (categoryState is CategoryLoaded && categoryState.categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أضف قسم أولا قبل إضافة منتج')),
      );
      return;
    }

    context.push(RouteNames.addProduct);
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        height: compact ? 56.h : 74.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Icon(icon, color: Colors.white, size: 22.sp),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyles.text16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
