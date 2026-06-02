import 'package:get_it/get_it.dart';

import '../../features/activity/data/datasource/activity_local_data_source.dart';
import '../../features/activity/data/repositories/activity_repository_impl.dart';
import '../../features/activity/domain/repositories/activity_repository.dart';
import '../../features/activity/domain/usecases/get_activities.dart';
import '../../features/activity/presentation/manger/cubits/activity_cubit.dart';
import '../../features/auth/data/datasource/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_use_case.dart';
import '../../features/auth/domain/usecases/reset_password_use_case.dart';
import '../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/domain/usecases/sign_out_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/presentation/cubits/auth_guard.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/categories/data/datasource/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category_use_case.dart';
import '../../features/categories/domain/usecases/delete_category_use_case.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/presentation/manger/cubits/category_cubit.dart';
import '../../features/inventory/data/datasource/inventory_local_data_source.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../features/inventory/domain/usecases/audit_product_use_case.dart';
import '../../features/inventory/domain/usecases/get_product_movements_use_case.dart';
import '../../features/inventory/presentation/cubits/inventory_cubit.dart';
import '../../features/products/data/datasource/product_local_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/add_product_use_case.dart';
import '../../features/products/domain/usecases/delete_product_use_case.dart';
import '../../features/products/domain/usecases/edit_product_use_case.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/presentation/manger/cubits/product_cubit.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_backup_metadata.dart';
import '../../features/settings/domain/usecases/restore_backup.dart';
import '../../features/settings/domain/usecases/upload_backup.dart';
import '../../features/settings/presentation/manger/cubits/settings_cubit.dart';
import '../../features/sales/data/datasource/sales_local_data_source.dart';
import '../../features/sales/data/repositories/sales_repository_impl.dart';
import '../../features/sales/domain/repositories/sales_repository.dart';
import '../../features/sales/domain/usecases/create_sale_use_case.dart';
import '../../features/sales/domain/usecases/get_today_sales_stats_use_case.dart';
import '../../features/sales/presentation/cubits/sales_cubit.dart';
import '../database/app_database.dart';
import 'backup_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  getIt.registerLazySingleton<BackupService>(
    () => BackupService(appDatabase: getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(() => AuthGuard(getIt<GetCurrentUserUseCase>()));
  getIt.registerLazySingleton(
    () => AuthCubit(
      getIt<SignUpUseCase>(),
      getIt<SignInUseCase>(),
      getIt<SignOutUseCase>(),
      getIt<ResetPasswordUseCase>(),
      getIt<GetCurrentUserUseCase>(),
    ),
  );

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

  getIt.registerLazySingleton<SalesLocalDataSource>(
    () => SalesLocalDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<SalesRepository>(
    () => SalesRepositoryImpl(getIt<SalesLocalDataSource>()),
  );
  getIt.registerLazySingleton(
    () => CreateSaleUseCase(getIt<SalesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetTodaySalesStatsUseCase(getIt<SalesRepository>()),
  );

  getIt.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(getIt<InventoryLocalDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetProductMovementsUseCase(getIt<InventoryRepository>()),
  );
  getIt.registerLazySingleton(
    () => AuditProductUseCase(getIt<InventoryRepository>()),
  );

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

  getIt.registerLazySingleton(
    () => SalesCubit(
      getIt<CreateSaleUseCase>(),
      getIt<GetTodaySalesStatsUseCase>(),
      onSaleSaved: () async {
        await getIt<ProductCubit>().loadProducts();
        await getIt<ActivityCubit>().loadActivities(refresh: true);
      },
    )..loadTodayStats(),
  );

  getIt.registerFactory(
    () => InventoryCubit(
      getIt<GetProductMovementsUseCase>(),
      getIt<AuditProductUseCase>(),
    ),
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<BackupService>()),
  );
  getIt.registerLazySingleton(
    () => GetBackupMetadata(getIt<SettingsRepository>()),
  );
  getIt.registerLazySingleton(() => UploadBackup(getIt<SettingsRepository>()));
  getIt.registerLazySingleton(() => RestoreBackup(getIt<SettingsRepository>()));
  getIt.registerLazySingleton(
    () => SettingsCubit(
      getIt<GetBackupMetadata>(),
      getIt<UploadBackup>(),
      getIt<RestoreBackup>(),
      onBackupRestored: () async {
        await getIt<CategoryCubit>().loadCategories();
        await getIt<ProductCubit>().loadProducts();
        await getIt<SalesCubit>().loadTodayStats();
        await getIt<ActivityCubit>().loadActivities(refresh: true);
      },
    ),
  );
}
