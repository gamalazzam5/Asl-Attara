import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future call() async {
    return await repository.getProducts();
  }
}
