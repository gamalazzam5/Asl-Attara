import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/text_style.dart';

class StockStatusBadge extends StatelessWidget {
  const StockStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),

      decoration: BoxDecoration(
        color: Colors.red.shade50,

        borderRadius: BorderRadius.circular(20.r),

        border: Border.all(color: Colors.red.shade200),
      ),

      child: Text(
        'مخزون منخفض',

        style: TextStyles.text12.copyWith(color: Colors.red),
      ),
    );
  }
}
