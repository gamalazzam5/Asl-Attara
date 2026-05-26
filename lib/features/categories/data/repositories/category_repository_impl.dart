import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

import '../../../activity/data/datasource/activity_local_data_source.dart';
import '../../../activity/data/models/activity_log_model.dart';
import '../datasource/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final ActivityLocalDataSource activityLocalDataSource;

  CategoryRepositoryImpl(this.localDataSource, this.activityLocalDataSource);

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
    await _addActivity(
      action: 'add',
      category: category,
      description: 'تمت إضافة القسم "${category.title}"',
    );
  }

  @override
  Future<void> deleteCategory(CategoryEntity category) async {
    await localDataSource.deleteCategory(category.id);

    await _addActivity(
      action: 'delete',
      category: category,
      description: 'تم حذف القسم "${category.title}"',
    );
  }

  Future<void> _addActivity({
    required String action,
    required CategoryEntity category,
    required String description,
  }) async {
    await activityLocalDataSource.addActivity(
      ActivityLogModel(
        action: action,
        targetType: 'category',
        targetId: category.id,
        targetName: category.title,
        description: description,
        createdAt: DateTime.now(),
      ),
    );
  }
}
