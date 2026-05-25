import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/custom_bottom_navbar.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/views/categories_view.dart';

import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/views/products_view.dart';

import '../../../dashboard/presentation/views/dashboard_view.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<CategoryCubit>()),
        BlocProvider.value(value: getIt<ProductCubit>()),
      ],
      child: const _NavigationBody(),
    );
  }
}

class _NavigationBody extends StatefulWidget {
  const _NavigationBody({super.key});

  @override
  State<_NavigationBody> createState() => _NavigationBodyState();
}

class _NavigationBodyState extends State<_NavigationBody> {
  int currentIndex = 0;

  final pages = const [DashboardView(), CategoriesView(), ProductsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // لا يوجد FAB هنا — كل صفحة بتدير الـ FAB بتاعها بنفسها
      // مشكلة الـ duplicate hero اتحلت في ProductsView بإضافة heroTag فريد
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
