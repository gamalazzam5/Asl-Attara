import '../../../../core/database/tables/inventory_log_table.dart';
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
    await localDataSource.addProduct(_toModel(product));

    await _addActivity(
      action: 'product_added',
      product: product,
      description: 'تمت إضافة المنتج "${product.name}"',
    );

    await _addInventoryMovement(
      product: product,
      changeQuantity: product.quantity,
      quantityBefore: 0,
      quantityAfter: product.quantity,
      type: 'stock_added',
      description: 'إضافة مخزون ${product.quantity} ${product.unit}',
    );
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final oldProducts = await localDataSource.getProducts();
    ProductEntity? oldProduct;

    for (final item in oldProducts) {
      if (item.id == product.id) {
        oldProduct = item;
        break;
      }
    }

    await localDataSource.updateProduct(_toModel(product));

    await _addActivity(
      action: 'product_edited',
      product: product,
      description: 'تم تعديل المنتج "${product.name}"',
    );

    if (oldProduct != null && oldProduct.quantity != product.quantity) {
      final changeQuantity = product.quantity - oldProduct.quantity;
      await _addInventoryMovement(
        product: product,
        changeQuantity: changeQuantity,
        quantityBefore: oldProduct.quantity,
        quantityAfter: product.quantity,
        type: 'inventory_updated',
        description:
            'تعديل المخزون ${changeQuantity > 0 ? '+' : ''}${changeQuantity.toStringAsFixed(2)} ${product.unit}',
      );
    }
  }

  @override
  Future<void> deleteProduct(ProductEntity product) async {
    await localDataSource.deleteProduct(product.id);

    await _addActivity(
      action: 'product_deleted',
      product: product,
      description: 'تم حذف المنتج "${product.name}"',
    );
  }

  ProductModel _toModel(ProductEntity product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      quantity: product.quantity,
      unit: product.unit,
      minimumStockQuantity: product.minimumStockQuantity,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      buyPrice: product.buyPrice,
      sellPrice: product.sellPrice,
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

  Future<void> _addInventoryMovement({
    required ProductEntity product,
    required double changeQuantity,
    required double quantityBefore,
    required double quantityAfter,
    required String type,
    required String description,
  }) async {
    final db = await localDataSource.appDatabase.database;
    final now = DateTime.now();

    await db.insert(InventoryLogTable.tableName, {
      InventoryLogTable.id: now.microsecondsSinceEpoch,
      InventoryLogTable.productId: product.id,
      InventoryLogTable.productName: product.name,
      InventoryLogTable.changeQuantity: changeQuantity,
      InventoryLogTable.quantityBefore: quantityBefore,
      InventoryLogTable.quantityAfter: quantityAfter,
      InventoryLogTable.type: type,
      InventoryLogTable.description: description,
      InventoryLogTable.createdAt: now.millisecondsSinceEpoch,
    });
  }
}
