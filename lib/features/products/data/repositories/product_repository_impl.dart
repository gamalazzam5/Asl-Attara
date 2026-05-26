import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

import '../../../activity/data/datasource/activity_local_data_source.dart';
import '../../../activity/data/models/activity_log_model.dart';
import '../datasource/product_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ActivityLocalDataSource activityLocalDataSource;

  ProductRepositoryImpl(this.localDataSource, this.activityLocalDataSource);

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

    await _addActivity(
      action: 'add',
      product: product,
      description: 'تمت إضافة المنتج "${product.name}"',
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

    await _addActivity(
      action: 'update',
      product: product,
      description: 'تم تعديل المنتج "${product.name}"',
    );
  }

  @override
  Future<void> deleteProduct(ProductEntity product) async {
    await localDataSource.deleteProduct(product.id);

    await _addActivity(
      action: 'delete',
      product: product,
      description: 'تم حذف المنتج "${product.name}"',
    );
  }

  Future<void> _addActivity({
    required String action,
    required ProductEntity product,
    required String description,
  }) async {
    await activityLocalDataSource.addActivity(
      ActivityLogModel(
        action: action,
        targetType: 'product',
        targetId: product.id,
        targetName: product.name,
        description: description,
        createdAt: DateTime.now(),
      ),
    );
  }
}
