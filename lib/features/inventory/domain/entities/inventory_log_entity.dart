class InventoryLogEntity {
  final int id;
  final int productId;
  final String productName;
  final double changeQuantity;
  final double quantityBefore;
  final double quantityAfter;
  final String type;
  final String description;
  final DateTime createdAt;

  const InventoryLogEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.changeQuantity,
    required this.quantityBefore,
    required this.quantityAfter,
    required this.type,
    required this.description,
    required this.createdAt,
  });
}
