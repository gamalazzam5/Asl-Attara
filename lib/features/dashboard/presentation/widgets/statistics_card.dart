import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_style.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isAlert;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),

      decoration: BoxDecoration(
        color: isAlert
            ? Colors.red.shade50
            : Colors.white,

        borderRadius: BorderRadius.circular(
          20.r,
        ),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.text14,
          ),

          SizedBox(height: 12.h),

          Text(
            value,
            style: TextStyles.text24.copyWith(
              fontWeight: FontWeight.bold,
              color: isAlert
                  ? Colors.red
                  : Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }
}