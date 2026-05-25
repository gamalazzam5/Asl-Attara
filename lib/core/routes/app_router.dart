import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/features/splash/splash.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/manger/cubits/category_cubit.dart';

import '../../features/dashboard/presentation/views/dashboard_view.dart';

import '../../features/navigation/presentation/views/main_navigation_view.dart';

import '../../features/products/domain/entities/product_entity.dart';
import '../../features/products/presentation/manger/cubits/product_cubit.dart';

import '../../features/products/presentation/views/add_product_view.dart';

import '../../features/products/presentation/views/edit_product_view.dart';
import '../../features/products/presentation/views/products_view.dart';

import '../services/service_locator.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,

    routes: [
      GoRoute(
        path: RouteNames.splash,

        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: RouteNames.dashboard,

        builder: (context, state) => const DashboardView(),
      ),

      GoRoute(
        path: RouteNames.mainNavigation,

        builder: (context, state) => const MainNavigationView(),
      ),

      /// Add Product
      GoRoute(
        path: RouteNames.addProduct,

        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<CategoryCubit>()..loadCategories(),

            child: const AddProductView(),
          );
        },
      ),

      /// Products by category
      GoRoute(
        path: RouteNames.categoryProducts,

        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;

          return BlocProvider(
            create: (_) => getIt<ProductCubit>(),

            child: ProductsView(
              categoryId: data['id'],

              categoryName: data['name'],
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.editProduct,

        builder: (context, state) {
          final product = state.extra as ProductEntity;

          return BlocProvider(
            create: (_) => getIt<CategoryCubit>()..loadCategories(),

            child: EditProductView(product: product),
          );
        },
      ),
    ],
  );
}
