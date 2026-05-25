import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/features/splash/splash.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/categories/presentation/manger/cubits/category_cubit.dart';

import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/dashboard/presentation/views/low_stock_view.dart';

import '../../features/navigation/presentation/views/main_navigation_view.dart';

import '../../features/products/domain/entities/product_entity.dart';

import '../../features/products/domain/usecases/add_product_use_case.dart';
import '../../features/products/domain/usecases/edit_product_use_case.dart';
import '../../features/products/domain/usecases/get_products.dart';

import '../../features/products/presentation/manger/cubits/product_cubit.dart';

import '../../features/products/presentation/views/add_product_view.dart';
import '../../features/products/presentation/views/edit_product_view.dart';
import '../../features/products/presentation/views/product_details_view.dart';
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
          final extra = state.extra as Map<String, dynamic>?;
          final cubit =
              (extra?['cubit'] as ProductCubit?) ?? getIt<ProductCubit>();
          // بناخد الـ categoryId من الـ extra لو موجود
          final categoryId = extra?['categoryId'] as int?;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: getIt<CategoryCubit>()),
            ],
            // بنبعت الـ categoryId للـ AddProductView
            child: AddProductView(categoryId: categoryId),
          );
        },
      ),

      /// Products by category
      GoRoute(
        path: RouteNames.categoryProducts,
        builder: (_, state) {
          final data = state.extra as Map<String, dynamic>;

          final categoryCubit = ProductCubit(
            getIt<GetProducts>(),
            getIt<AddProduct>(),
            getIt<UpdateProduct>(),
          );

          return BlocProvider(
            create: (_) =>
                categoryCubit..loadProducts(categoryId: data['id'] as int),
            child: ProductsView(
              categoryId: data['id'] as int,
              categoryName: data['name'] as String,
              categoryProductCubit: categoryCubit,
            ),
          );
        },
      ),

      /// Product Details
      GoRoute(
        path: RouteNames.productDetails,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          final product = extra['product'] as ProductEntity;
          final cubit =
              (extra['cubit'] as ProductCubit?) ?? getIt<ProductCubit>();

          return BlocProvider.value(
            value: cubit,
            child: ProductDetailsView(product: product),
          );
        },
      ),

      /// Edit Product
      GoRoute(
        path: RouteNames.editProduct,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          final product = extra['product'] as ProductEntity;
          final cubit =
              (extra['cubit'] as ProductCubit?) ?? getIt<ProductCubit>();

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: getIt<CategoryCubit>()),
            ],
            child: EditProductView(product: product),
          );
        },
      ),

      /// Low Stock
      GoRoute(
        path: RouteNames.lowStock,
        builder: (_, __) {
          return BlocProvider.value(
            value: getIt<ProductCubit>(),
            child: const LowStockView(),
          );
        },
      ),
    ],
  );
}
