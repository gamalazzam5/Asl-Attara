import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_names.dart';

import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/manger/cubits/product_state.dart';

import '../widgets/backup_status_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/recent_activity_item.dart';
import '../widgets/statistics_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            int totalProducts = 0;

            int lowStockProducts = 0;

            if (state is ProductLoaded) {
              totalProducts = state.products.length;

              lowStockProducts = state.products
                  .where((product) => product.lowStock)
                  .length;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),

              child: Column(
                children: [
                  const DashboardHeader(),

                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCard(
                          title: 'إجمالي المنتجات',
                          value: totalProducts.toString(),

                          icon: Icons.inventory_2_outlined,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: StatisticsCard(
                          title: 'منخفض المخزون',

                          value: lowStockProducts.toString(),

                          isAlert: true,

                          icon: Icons.warning_rounded,

                          onTap: () {
                            context.push(RouteNames.lowStock);
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  const QuickActionButton(),

                  SizedBox(height: 24.h),

                  const RecentActivityItem(),

                  SizedBox(height: 20.h),

                  const BackupStatusCard(),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
