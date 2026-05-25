import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;

  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  Color getColor(String hex) {
    hex = hex.replaceAll('#', '');

    return Color(int.parse('0xFF$hex'));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(24.r),

      child: Container(
        padding: EdgeInsets.all(20.r),

        decoration: BoxDecoration(
          color: getColor(category.backgroundColor),

          borderRadius: BorderRadius.circular(24.r),
        ),

        child: Column(
          mainAxisAlignment: .spaceBetween,

          children: [
            Container(
              padding: EdgeInsets.all(12.r),

              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .6),

                shape: BoxShape.circle,
              ),

              child: Image.asset(category.imagePath, width: 28.r, height: 28.r),
            ),

            Text(
              category.title,

              style: TextStyles.text16.copyWith(
                color: AppColors.primaryColor,

                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              '${category.itemCount} منتج',

              style: TextStyles.text14.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
