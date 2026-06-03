class SaleItemEntity {
  final int id;
  final int saleId;
  final int productId;
  final String productName;
  final double enteredAmount;
  final double calculatedQuantity;
  final double quantity;
  final String unit;
  final double buyPrice;
  final double sellPrice;
  final double totalAmount;
  final double profit;

  const SaleItemEntity({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.enteredAmount,
    required this.calculatedQuantity,
    required this.quantity,
    required this.unit,
    required this.buyPrice,
    required this.sellPrice,
    required this.totalAmount,
    required this.profit,
  });
}
