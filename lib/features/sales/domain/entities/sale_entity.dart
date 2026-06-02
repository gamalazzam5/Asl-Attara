import 'sale_item_entity.dart';

class SaleEntity {
  final int id;
  final double totalAmount;
  final double totalProfit;
  final DateTime createdAt;
  final List<SaleItemEntity> items;

  const SaleEntity({
    required this.id,
    required this.totalAmount,
    required this.totalProfit,
    required this.createdAt,
    required this.items,
  });
}
