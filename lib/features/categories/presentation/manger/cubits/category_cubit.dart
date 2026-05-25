import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/add_category_use_case.dart';
import '../../../domain/usecases/get_categories.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategoriesUseCase;
  final AddCategory addCategoryUseCase;

  CategoryCubit(this.getCategoriesUseCase, this.addCategoryUseCase)
    : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    final categories = await getCategoriesUseCase();

    emit(CategoryLoaded(categories));
  }

  Future<bool> addCategory({
    required String title,
    required String color,
  }) async {
    final categories = await getCategoriesUseCase();

    final exists = categories.any(
      (category) =>
          category.title.trim().toLowerCase() == title.trim().toLowerCase(),
    );

    if (exists) {
      return false;
    }

    final category = CategoryEntity(
      id: DateTime.now().millisecondsSinceEpoch,

      title: title,

      itemCount: '0',

      imagePath: 'assets/images/greens.png',

      backgroundColor: color,
    );

    await addCategoryUseCase(category);

    await loadCategories();

    return true;
  }
}
