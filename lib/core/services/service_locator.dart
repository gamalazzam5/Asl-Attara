import 'package:get_it/get_it.dart';

import '../../features/categories/data/datasource/category_local_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';

import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/get_categories.dart';

import '../../features/categories/presentation/manger/cubits/category_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  /// DataSource
  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSource(),
  );

  /// Repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<CategoryLocalDataSource>()),
  );

  /// UseCase
  getIt.registerLazySingleton(() => GetCategories(getIt()));

  /// Cubit
  getIt.registerFactory(() => CategoryCubit(getIt()));
}
