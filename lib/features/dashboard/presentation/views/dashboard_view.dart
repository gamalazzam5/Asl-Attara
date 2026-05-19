import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/nav_bar.dart';
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
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0,),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [

              const DashboardHeader(),

              SizedBox(height: 24.h),

              Row(
                children: [

                  Expanded(
                    child: StatisticsCard(
                      title: 'منتجات منخفضة المخزون',
                      value: '12',
                      isAlert: true,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: StatisticsCard(
                      title: 'إجمالي المنتجات',
                      value: '154',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              const QuickActionButton(),

              SizedBox(height: 24.h),

              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (_, index) {
                    return RecentActivityItem();
                  },
                ),
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