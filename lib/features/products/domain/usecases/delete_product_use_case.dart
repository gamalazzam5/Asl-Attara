import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> call(ProductEntity product) async {
    await repository.deleteProduct(product);
  }
}
