import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/backup_status_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/recent_activity_item.dart';
import '../widgets/statistics_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              const DashboardHeader(),
              SizedBox(height: 24.h),

              // Statistics Cards Row
              Row(
                children: [
                  Expanded(
                    child: StatisticsCard(
                      title: 'إجمالي المنتجات',
                      value: '154',
                      isAlert: false,
                      icon: Icons.delete_outline_rounded,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: StatisticsCard(
                      title: ' منخفض المخزون',
                      value: '12',
                      isAlert: true,
                      icon: Icons.warning_rounded,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              const QuickActionButton(),

              SizedBox(height: 24.h),

              Expanded(
                child: RecentActivityItem(),
              ),

              SizedBox(height: 16.h),

              const BackupStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}