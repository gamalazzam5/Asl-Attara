import '../../../../core/database/tables/sale_table.dart';
import '../../domain/entities/sale_entity.dart';
import 'sale_item_model.dart';

class SaleModel extends SaleEntity {
  const SaleModel({
    required super.id,
    required super.totalAmount,
    required super.totalProfit,
    required super.createdAt,
    required super.items,
  });

  factory SaleModel.fromJson(
    Map<String, dynamic> json, {
    List<SaleItemModel> items = const [],
  }) {
    return SaleModel(
      id: json[SaleTable.id] as int,
      totalAmount: (json[SaleTable.totalAmount] as num).toDouble(),
      totalProfit: (json[SaleTable.totalProfit] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json[SaleTable.createdAt] as int,
      ),
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SaleTable.id: id,
      SaleTable.totalAmount: totalAmount,
      SaleTable.totalProfit: totalProfit,
      SaleTable.createdAt: createdAt.millisecondsSinceEpoch,
    };
  }
}
