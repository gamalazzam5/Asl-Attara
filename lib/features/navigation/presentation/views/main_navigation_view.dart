import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/custom_bottom_navbar.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/views/categories_view.dart';

import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/views/products_view.dart';

import '../../../dashboard/presentation/views/dashboard_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const DashboardView(),

      const CategoriesView(),

      const ProductsView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CategoryCubit>()),

        BlocProvider(create: (_) => getIt<ProductCubit>()),
      ],

      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: pages),

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
