import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/features/splash/splash.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/navigation/presentation/views/main_navigation_view.dart';

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
        builder: (context,state)
        => const MainNavigationView(),
      ),

      // GoRoute(
      //   path: RouteNames.products,
      //   builder: (context, state) => const ProductsView(),
      // ),
      //
      // GoRoute(
      //   path: RouteNames.categories,
      //   builder: (context, state) => const CategoriesView(),
      // ),
      //
      // GoRoute(
      //   path: RouteNames.inventory,
      //   builder: (context, state) =>
      //   const InventoryHistoryView(),
      // ),
      //
      // GoRoute(
      //   path: RouteNames.backup,
      //   builder: (context, state) => const BackupView(),
      // ),
      //
      // GoRoute(
      //   path: RouteNames.settings,
      //   builder: (context, state) => const SettingsView(),
      // ),
    ],
  );
}