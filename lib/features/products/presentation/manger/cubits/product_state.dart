import '../../../domain/entities/product_entity.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;

  final List<ProductEntity> filteredProducts;

  ProductLoaded({required this.products, required this.filteredProducts});
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
