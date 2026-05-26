import 'package:get_it/get_it.dart';

import '../../features/activity/data/datasource/activity_local_data_source.dart';
import '../../features/activity/data/repositories/activity_repository_impl.dart';
import '../../features/activity/domain/repositories/activity_repository.dart';
import '../../features/activity/domain/usecases/get_activities.dart';
import '../../features/activity/presentation/manger/cubits/activity_cubit.dart';
import '../../features/categories/data/datasource/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category_use_case.dart';
import '../../features/categories/domain/usecases/delete_category_use_case.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/presentation/manger/cubits/category_cubit.dart';
import '../../features/products/data/datasource/product_local_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/add_product_use_case.dart';
import '../../features/products/domain/usecases/delete_product_use_case.dart';
import '../../features/products/domain/usecases/edit_product_use_case.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/manger/cubits/product_cubit.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<ActivityLocalDataSource>(
    () => ActivityLocalDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(getIt<ActivityLocalDataSource>()),
  );
  getIt.registerLazySingleton(() => GetActivities(getIt<ActivityRepository>()));
  getIt.registerLazySingleton(
    () => ActivityCubit(getIt<GetActivities>())..loadActivities(),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<ProductLocalDataSource>(),
      getIt<ActivityLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton(() => GetProducts(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => AddProduct(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => UpdateProduct(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => DeleteProduct(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => SearchProducts());

  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      getIt<CategoryLocalDataSource>(),
      getIt<ActivityLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton(() => GetCategories(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(() => AddCategory(getIt<CategoryRepository>()));
  getIt.registerLazySingleton(
    () => DeleteCategory(getIt<CategoryRepository>()),
  );

  getIt.registerLazySingleton(
    () => CategoryCubit(
      getIt<GetCategories>(),
      getIt<AddCategory>(),
      getIt<DeleteCategory>(),
      onActivityChanged: () =>
          getIt<ActivityCubit>().loadActivities(refresh: true),
    )..loadCategories(),
  );

  getIt.registerLazySingleton(
    () => ProductCubit(
      getIt<GetProducts>(),
      getIt<AddProduct>(),
      getIt<UpdateProduct>(),
      deleteProductUseCase: getIt<DeleteProduct>(),
      onProductChanged: () => getIt<CategoryCubit>().loadCategories(),
      onActivityChanged: () =>
          getIt<ActivityCubit>().loadActivities(refresh: true),
    )..loadProducts(),
  );
}
