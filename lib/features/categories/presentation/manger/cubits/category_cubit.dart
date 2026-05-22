import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_categories.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories getCategoriesUseCase;

  CategoryCubit(this.getCategoriesUseCase) : super(CategoryInitial());

  Future<void> loadCategories() async {
    try {
      emit(CategoryLoading());

      final categories = await getCategoriesUseCase();

      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
