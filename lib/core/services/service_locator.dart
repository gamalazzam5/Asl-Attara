import 'package:get_it/get_it.dart';

/// Categories
import '../../features/categories/data/datasource/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/presentation/manger/cubits/category_cubit.dart';

/// Products
import '../../features/products/data/datasource/product_local_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/manger/cubits/product_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  /// =========================
  /// Categories
  /// =========================

  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(),
  );

  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<CategoryLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => GetCategories(getIt()));

  getIt.registerFactory(() => CategoryCubit(getIt()));

  /// =========================
  /// Products
  /// =========================

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => GetProducts(getIt<ProductRepository>()));

  getIt.registerLazySingleton(() => SearchProducts());

  getIt.registerFactory(() => ProductCubit(getIt<GetProducts>()));
}
