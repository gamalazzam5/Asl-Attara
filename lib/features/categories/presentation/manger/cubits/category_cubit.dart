import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/add_category_use_case.dart';
import '../../../domain/usecases/delete_category_use_case.dart';
import '../../../domain/usecases/get_categories.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategoriesUseCase;
  final AddCategory addCategoryUseCase;
  final DeleteCategory deleteCategoryUseCase;
  final Future<void> Function()? onActivityChanged;

  CategoryCubit(
    this.getCategoriesUseCase,
    this.addCategoryUseCase,
    this.deleteCategoryUseCase, {
    this.onActivityChanged,
  }) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());

    try {
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<bool> addCategory({
    required String title,
    required String color,
  }) async {
    try {
      final categories = await getCategoriesUseCase();
      final normalizedTitle = title.trim().toLowerCase();

      final exists = categories.any(
        (category) => category.title.trim().toLowerCase() == normalizedTitle,
      );

      if (exists) return false;

      final category = CategoryEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title.trim(),
        itemCount: '0',
        imagePath: 'assets/images/greens.png',
        backgroundColor: color,
      );

      await addCategoryUseCase(category);
      await loadCategories();
      await onActivityChanged?.call();
      return true;
    } catch (e) {
      emit(CategoryError(e.toString()));
      return false;
    }
  }

  Future<void> refreshCategoryCounts() async {
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<bool> deleteCategory(CategoryEntity category) async {
    if (int.tryParse(category.itemCount) != 0) return false;

    try {
      await deleteCategoryUseCase(category);
      await loadCategories();
      await onActivityChanged?.call();
      return true;
    } catch (e) {
      emit(CategoryError(e.toString()));
      return false;
    }
  }
}
