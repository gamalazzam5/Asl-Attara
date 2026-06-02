import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/manger/cubits/product_state.dart';
import '../../../sales/presentation/cubits/sales_cubit.dart';
import '../../../sales/presentation/cubits/sales_state.dart';
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
    context.read<SalesCubit>().loadTodayStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, productState) {
            var totalProducts = 0;
            var lowStockProducts = 0;

            if (productState is ProductLoaded) {
              totalProducts = productState.products.length;
              lowStockProducts = productState.products
                  .where((product) => product.lowStock)
                  .length;
            }

            final salesState = context.watch<SalesCubit>().state;
            var totalSalesToday = 0.0;
            var totalProfitToday = 0.0;

            if (salesState is SalesStatsLoaded) {
              totalSalesToday = salesState.stats.totalSalesToday;
              totalProfitToday = salesState.stats.totalProfitToday;
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
                          onTap: () => context.push(RouteNames.lowStock),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: StatisticsCard(
                          title: 'مبيعات اليوم',
                          value: '${totalSalesToday.toStringAsFixed(0)} ج',
                          icon: Icons.point_of_sale,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: StatisticsCard(
                          title: 'أرباح اليوم',
                          value: '${totalProfitToday.toStringAsFixed(0)} ج',
                          icon: Icons.trending_up,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const QuickActionButton(),
                  SizedBox(height: 24.h),
                  const RecentActivityItem(),
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
