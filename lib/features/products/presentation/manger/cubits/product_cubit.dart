import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_use_case.dart';
import '../../../domain/usecases/edit_product_use_case.dart';
import '../../../domain/usecases/get_products.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProductsUseCase;
  final AddProduct addProductUseCase;
  final UpdateProduct updateProductUseCase;

  ProductCubit(
    this.getProductsUseCase,
    this.addProductUseCase,
    this.updateProductUseCase,
  ) : super(ProductInitial());

  /// كل المنتجات من الـ data source
  List<ProductEntity> _allProducts = [];

  /// المنتجات الحالية (قسم معين أو كل المنتجات)
  List<ProductEntity> _currentProducts = [];

  /// الـ categoryId المحفوظ عشان نعمل reload صح بعد add/edit
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

    // Reload بنفس الـ categoryId المحفوظ
    await loadProducts(categoryId: _activeCategoryId);

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

    // Reload بنفس الـ categoryId المحفوظ
    await loadProducts(categoryId: _activeCategoryId);

    return true;
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
