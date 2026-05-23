import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../domain/usecases/get_products.dart';
import '../../../domain/usecases/search_products.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProducts;

  final SearchProducts searchProducts;

  ProductCubit(this.getProducts, this.searchProducts) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading());

      final products = await getProducts();

      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void search(String query) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;

      final filtered = searchProducts(products: current.products, query: query);

      emit(
        ProductLoaded(products: current.products, filteredProducts: filtered),
      );
    }
  }
}
