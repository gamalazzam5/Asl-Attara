import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

import '../datasource/product_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<ProductEntity>> getProducts() {
    return localDataSource.getProducts();
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    await localDataSource.addProduct(
      ProductModel(
        id: product.id,

        name: product.name,

        quantity: product.quantity,

        unit: product.unit,

        minimumStockQuantity: product.minimumStockQuantity,

        categoryId: product.categoryId,

        categoryName: product.categoryName,

        buyPrice: product.buyPrice,

        sellPrice: product.sellPrice,
      ),
    );
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await localDataSource.updateProduct(
      ProductModel(
        id: product.id,

        name: product.name,

        quantity: product.quantity,

        unit: product.unit,

        minimumStockQuantity: product.minimumStockQuantity,

        categoryId: product.categoryId,

        categoryName: product.categoryName,

        buyPrice: product.buyPrice,

        sellPrice: product.sellPrice,
      ),
    );
  }
}
