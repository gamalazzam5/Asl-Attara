import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_use_case.dart';
import '../../../domain/usecases/delete_product_use_case.dart';
import '../../../domain/usecases/edit_product_use_case.dart';
import '../../../domain/usecases/get_products.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;
  final DeleteProduct deleteProductUseCase;

  final Future<void> Function()? onProductChanged;
  final Future<void> Function()? onActivityChanged;

  ProductCubit(
    this.getProductsUseCase,
    this.addProductUseCase,
    this.updateProductUseCase, {
    required this.deleteProductUseCase,
    this.onProductChanged,
    this.onActivityChanged,
  }) : super(ProductInitial());

  List<ProductEntity> _allProducts = [];
  List<ProductEntity> _currentProducts = [];
  int? _activeCategoryId;

  Future<void> loadProducts({int? categoryId}) async {
    emit(ProductLoading());

    try {
      _activeCategoryId = categoryId;
      _allProducts = await getProductsUseCase();

      if (categoryId != null) {
        _currentProducts = _allProducts
            .where((product) => product.categoryId == categoryId)
            .toList();
      } else {
        _currentProducts = List.from(_allProducts);
      }

      emit(
        ProductLoaded(
          products: _allProducts,
          filteredProducts: _currentProducts,
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<bool> addProduct(ProductEntity product) async {
    final exists = _allProducts.any(
      (p) => p.name.trim().toLowerCase() == product.name.trim().toLowerCase(),
    );

    if (exists) return false;

    await addProductUseCase(product);
    await loadProducts(categoryId: _activeCategoryId);

    await onProductChanged?.call();
    await onActivityChanged?.call();

    return true;
  }

  Future<bool> updateProduct(ProductEntity product) async {
    final exists = _allProducts.any(
      (p) =>
          p.id != product.id &&
          p.name.trim().toLowerCase() == product.name.trim().toLowerCase(),
    );

    if (exists) return false;

    await updateProductUseCase(product);
    await loadProducts(categoryId: _activeCategoryId);

    await onProductChanged?.call();
    await onActivityChanged?.call();

    return true;
  }

  Future<bool> deleteProduct(ProductEntity product) async {
    try {
      await deleteProductUseCase(product);
      await loadProducts(categoryId: _activeCategoryId);
      await onProductChanged?.call();
      await onActivityChanged?.call();
      return true;
    } catch (e) {
      emit(ProductError(e.toString()));
      return false;
    }
  }

  void search(String query) {
    if (state is! ProductLoaded) return;

    final filtered = query.isEmpty
        ? _currentProducts
        : _currentProducts.where((product) {
            return product.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

    emit(ProductLoaded(products: _allProducts, filteredProducts: filtered));
  }
}
