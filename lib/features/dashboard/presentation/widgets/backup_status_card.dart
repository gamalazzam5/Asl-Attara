import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupStatusCard extends StatelessWidget {
  const BackupStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(14.r),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(14.r),
      ),

      child: const Text(
        "حالة النسخ الاحتياطي : تم بنجاح منذ ساعة",
        textAlign: TextAlign.center,
      ),
    );
  }
}
