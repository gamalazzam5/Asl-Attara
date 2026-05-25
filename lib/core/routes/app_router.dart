import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/features/splash/splash.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/manger/cubits/category_cubit.dart';

import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/dashboard/presentation/views/low_stock_view.dart';

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
      GoRoute(path: RouteNames.splash, builder: (_, __) => const SplashView()),

      GoRoute(
        path: RouteNames.dashboard,
        builder: (_, __) => const DashboardView(),
      ),

      GoRoute(
        path: RouteNames.mainNavigation,
        builder: (_, __) => const MainNavigationView(),
      ),

      /// Add Product
      GoRoute(
        path: RouteNames.addProduct,

        builder: (_, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<ProductCubit>()),

              BlocProvider.value(value: getIt<CategoryCubit>()),
            ],

            child: const AddProductView(),
          );
        },
      ),

      /// Products by Category
      GoRoute(
        path: RouteNames.categoryProducts,

        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;

          return BlocProvider.value(
            value: getIt<ProductCubit>()..loadProducts(categoryId: data['id']),

            child: ProductsView(
              categoryId: data['id'],
              categoryName: data['name'],
            ),
          );
        },
      ),

      /// Edit Product
      GoRoute(
        path: RouteNames.editProduct,

        builder: (_, state) {
          final product = state.extra as ProductEntity;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<ProductCubit>()),

              BlocProvider.value(value: getIt<CategoryCubit>()),
            ],

            child: EditProductView(product: product),
          );
        },
      ),

      /// Low Stock
      GoRoute(
        path: RouteNames.lowStock,

        builder: (_, state) {
          return BlocProvider.value(
            value: getIt<ProductCubit>(),

            child: const LowStockView(),
          );
        },
      ),
    ],
  );
}
