class ProductEntity {

  final int id;
  final String name;
  final double quantity;
  final String unit;

  final bool lowStock;

  final int categoryId;
  final String categoryName;

  final double buyPrice;
  final double sellPrice;

  ProductEntity({

    required this.id,
    required this.name,

    required this.quantity,
    required this.unit,

    required this.lowStock,

    required this.categoryId,
    required this.categoryName,

    required this.buyPrice,
    required this.sellPrice,
  });

}