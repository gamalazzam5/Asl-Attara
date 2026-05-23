import '../entities/product_entity.dart';

class SearchProducts {
  List<ProductEntity> call({
    required List<ProductEntity> products,

    required String query,
  }) {
    if (query.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
