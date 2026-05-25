import '../models/product_model.dart';

class ProductLocalDataSource {
  final List<ProductModel> _products = [
    ProductModel(
      id: 1,
      name: 'زعتر جاف',
      quantity: 5.5,
      unit: 'كجم',
      minimumStockQuantity: 10,
      categoryId: 1,
      categoryName: 'أعشاب',
      buyPrice: 45,
      sellPrice: 65,
    ),

    ProductModel(
      id: 2,
      name: 'زيت زيتون',
      quantity: 2,
      unit: 'لتر',
      minimumStockQuantity: 1,
      categoryId: 3,
      categoryName: 'زيوت',
      buyPrice: 80,
      sellPrice: 120,
    ),
  ];

  Future<List<ProductModel>> getProducts() async {
    return _products;
  }

  Future<void> addProduct(ProductModel product) async {
    _products.add(product);
  }

  Future<void> updateProduct(ProductModel product) async {
    final index = _products.indexWhere((e) => e.id == product.id);

    if (index != -1) {
      _products[index] = product;
    }
  }
}
