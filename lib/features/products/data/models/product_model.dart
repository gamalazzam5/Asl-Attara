import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.minimumStockQuantity,
    required super.categoryId,
    required super.unit,

    required super.categoryName,

    required super.buyPrice,
    required super.sellPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],

      name: json['name'],
      unit: json['unit'],
      quantity: json['quantity'],

      minimumStockQuantity: json['minimumStockQuantity'],
      categoryId: json['categoryId'],

      categoryName: json['categoryName'],

      buyPrice: json['buyPrice'],

      sellPrice: json['sellPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,

      'minimumStockQuantity': minimumStockQuantity,
      'categoryId': categoryId,

      'categoryName': categoryName,

      'buyPrice': buyPrice,

      'sellPrice': sellPrice,
    };
  }
}
