import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();

  Future<void> addCategory(CategoryEntity category);

  Future<void> deleteCategory(CategoryEntity category);
}
