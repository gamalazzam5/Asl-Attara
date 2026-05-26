import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../manger/cubits/activity_cubit.dart';
import '../manger/cubits/activity_state.dart';
import '../widgets/activity_tile.dart';

class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});

  @override
  State<ActivitiesView> createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends State<ActivitiesView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels <
        scrollController.position.maxScrollExtent - 160) {
      return;
    }

    final state = context.read<ActivityCubit>().state;
    if (state is ActivityLoaded && state.hasMore && !state.isLoadingMore) {
      context.read<ActivityCubit>().loadActivities();
    }
  }

  Future<void> _refresh() {
    return context.read<ActivityCubit>().loadActivities(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'كل العمليات',
          style: TextStyles.text18.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ActivityError) {
            return Center(child: Text(state.message));
          }

          if (state is ActivityLoaded) {
            if (state.activities.isEmpty) {
              return const Center(child: Text('لا توجد عمليات حتى الآن'));
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                controller: scrollController,
                padding: EdgeInsets.all(20.r),
                itemCount:
                    state.activities.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index >= state.activities.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ActivityTile(activity: state.activities[index]);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
