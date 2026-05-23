import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.lowStock,
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

      lowStock: json['lowStock'],

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

      'lowStock': lowStock,

      'categoryId': categoryId,

      'categoryName': categoryName,

      'buyPrice': buyPrice,

      'sellPrice': sellPrice,
    };
  }
}
