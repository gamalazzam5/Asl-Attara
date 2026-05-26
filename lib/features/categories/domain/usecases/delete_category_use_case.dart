import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(CategoryEntity category) async {
    await repository.deleteCategory(category);
  }
}
