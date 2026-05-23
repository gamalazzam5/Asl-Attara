import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class ProductImageAvatar extends StatelessWidget {
  const ProductImageAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      width: 110.w,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black12,

            blurRadius: 10.r,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Icon(
        Icons.inventory_2_outlined,

        size: 50.r,

        color: AppColors.primaryColor,
      ),
    );
  }
}
