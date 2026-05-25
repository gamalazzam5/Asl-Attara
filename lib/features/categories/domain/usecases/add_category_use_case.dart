import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(CategoryEntity category) async {
    await repository.addCategory(category);
  }
}
