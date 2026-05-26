import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/text_style.dart';

class RecentActivityProcess extends StatelessWidget {
  final String productName;

  const RecentActivityProcess({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 20.r, child: const Icon(Icons.add)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إضافة "$productName"',
                  style: TextStyles.text16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'تمت إضافته مؤخراً',
                  style: TextStyles.text12.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
