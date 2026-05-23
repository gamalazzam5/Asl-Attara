import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_products.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProducts;

  ProductCubit(this.getProducts) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading());

      final products = await getProducts();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
