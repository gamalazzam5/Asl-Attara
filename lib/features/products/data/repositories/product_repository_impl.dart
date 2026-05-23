import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

import '../datasource/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<ProductEntity>> getProducts() {
    return localDataSource.getProducts();
  }
}
