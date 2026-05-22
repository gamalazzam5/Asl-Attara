import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_bottom_navbar.dart';

import '../../../categories/data/datasource/category_local_data_source.dart';
import '../../../categories/data/repositories/category_repository_impl.dart';

import '../../../categories/domain/usecases/get_categories.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/views/categories_view.dart';

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

      BlocProvider(
        create: (_) => CategoryCubit(
          GetCategories(CategoryRepositoryImpl(CategoryLocalDataSource())),
        ),

        child: const CategoriesView(),
      ),

      Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
