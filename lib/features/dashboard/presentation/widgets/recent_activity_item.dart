import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'recent_activity_process.dart';

class RecentActivityItem extends StatelessWidget {
  final List<ProductEntity> products;

  const RecentActivityItem({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final recentProducts = products.reversed.take(3).toList();

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
        if (recentProducts.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              'لا توجد عمليات حتى الآن',
              style: TextStyles.text14.copyWith(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            itemCount: recentProducts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return RecentActivityProcess(
                productName: recentProducts[index].name,
              );
            },
          ),
      ],
    );
  }
}
