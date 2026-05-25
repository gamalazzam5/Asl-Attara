import 'package:aslattara/features/products/presentation/manger/cubits/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_use_case.dart';
import '../../../domain/usecases/edit_product_use_case.dart';
import '../../../domain/usecases/get_products.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase;

  final AddProduct addProductUseCase;

  final UpdateProduct updateProductUseCase;

  ProductCubit(
    this.getProductsUseCase,

    this.addProductUseCase,

    this.updateProductUseCase,
  ) : super(ProductInitial());

  List<ProductEntity> _allProducts = [];

  List<ProductEntity> _currentProducts = [];

  Future<void> loadProducts({int? categoryId}) async {
    emit(ProductLoading());

    _allProducts = await getProductsUseCase();

    _currentProducts = categoryId == null
        ? _allProducts
        : _allProducts.where((e) => e.categoryId == categoryId).toList();

    emit(
      ProductLoaded(
        products: _currentProducts,

        filteredProducts: _currentProducts,
      ),
    );
  }

  Future<bool> addProduct(ProductEntity product) async {
    final exists = _allProducts.any(
      (p) => p.name.trim().toLowerCase() == product.name.trim().toLowerCase(),
    );

    if (exists) {
      return false;
    }

    await addProductUseCase(product);

    await loadProducts();

    return true;
  }

  Future<bool> updateProduct(ProductEntity product) async {
    final exists = _allProducts.any(
      (p) =>
          p.id != product.id &&
          p.name.trim().toLowerCase() == product.name.trim().toLowerCase(),
    );

    if (exists) {
      return false;
    }

    await updateProductUseCase(product);

    await loadProducts();

    return true;
  }

  void search(String query) {
    if (state is! ProductLoaded) return;

    final filtered = query.isEmpty
        ? _currentProducts
        : _currentProducts
              .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    emit(ProductLoaded(products: _currentProducts, filteredProducts: filtered));
  }
}
