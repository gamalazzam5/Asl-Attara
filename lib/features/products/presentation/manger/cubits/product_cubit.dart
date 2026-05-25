import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase;

  ProductCubit(this.getProductsUseCase) : super(ProductInitial());

  List<ProductEntity> _allProducts = [];

  List<ProductEntity> _currentProducts = [];

  Future<void> loadProducts({int? categoryId}) async {
    try {
      emit(ProductLoading());

      _allProducts = await getProductsUseCase();

      _currentProducts = categoryId == null
          ? _allProducts
          : _allProducts.where((product) {
              return product.categoryId == categoryId;
            }).toList();

      emit(
        ProductLoaded(
          products: _currentProducts,

          filteredProducts: _currentProducts,
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void search(String query) {
    if (state is! ProductLoaded) {
      return;
    }

    final filtered = query.isEmpty
        ? _currentProducts
        : _currentProducts.where((product) {
            return product.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

    emit(ProductLoaded(products: _currentProducts, filteredProducts: filtered));
  }
}
