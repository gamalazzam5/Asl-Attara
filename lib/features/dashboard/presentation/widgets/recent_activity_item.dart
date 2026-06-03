import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/routes/route_names.dart';
import '../../../activity/presentation/manger/cubits/activity_cubit.dart';
import '../../../activity/presentation/manger/cubits/activity_state.dart';
import '../../../activity/presentation/widgets/activity_tile.dart';

class RecentActivityItem extends StatelessWidget {
  const RecentActivityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
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
              TextButton(
                onPressed: () => context.push(RouteNames.activities),
                child: Text(
                  'عرض الكل',
                  style: TextStyles.text14.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          BlocBuilder<ActivityCubit, ActivityState>(
            builder: (context, state) {
              if (state is ActivityLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ActivityLoaded && state.activities.isNotEmpty) {
                final recentActivities = state.activities.take(3).toList();

                return ListView.separated(
                  itemCount: recentActivities.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) {
                    return ActivityTile(activity: recentActivities[index]);
                  },
                );
              }

              return Container(
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
              );
            },
          ),
        ],
      ),
    );
  }
}
