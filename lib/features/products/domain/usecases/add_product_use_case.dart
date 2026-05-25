import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<void> call(ProductEntity product) async {
    await repository.addProduct(product);
  }
}
