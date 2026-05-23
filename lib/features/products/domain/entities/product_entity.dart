class ProductEntity {
  final int id;

  final String name;

  final double quantity;

  final String unit;

  final int categoryId;

  final String categoryName;

  final double buyPrice;

  final double sellPrice;

  final double minimumStockQuantity;

  ProductEntity({
    required this.id,

    required this.name,

    required this.quantity,

    required this.unit,

    required this.categoryId,

    required this.categoryName,

    required this.buyPrice,

    required this.sellPrice,

    required this.minimumStockQuantity,
  });

  bool get lowStock {
    return quantity <= minimumStockQuantity;
  }
}
