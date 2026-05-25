import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

import '../datasource/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() {
    return localDataSource.getCategories();
  }

  @override
  Future<void> addCategory(CategoryEntity category) async {
    final model = CategoryModel(
      id: category.id,

      title: category.title,

      itemCount: category.itemCount,

      imagePath: category.imagePath,

      backgroundColor: category.backgroundColor,
    );

    await localDataSource.addCategory(model);
  }
}
