import '../../../../core/database/tables/sale_item_table.dart';
import '../../domain/entities/sale_item_entity.dart';

class SaleItemModel extends SaleItemEntity {
  const SaleItemModel({
    required super.id,
    required super.saleId,
    required super.productId,
    required super.productName,
    required super.enteredAmount,
    required super.calculatedQuantity,
    required super.quantity,
    required super.unit,
    required super.buyPrice,
    required super.sellPrice,
    required super.totalAmount,
    required super.profit,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      id: json[SaleItemTable.id] as int,
      saleId: json[SaleItemTable.saleId] as int,
      productId: json[SaleItemTable.productId] as int,
      productName: json[SaleItemTable.productName] as String,
      enteredAmount:
          (json[SaleItemTable.enteredAmount] as num?)?.toDouble() ??
          (json[SaleItemTable.totalAmount] as num).toDouble(),
      calculatedQuantity:
          (json[SaleItemTable.calculatedQuantity] as num?)?.toDouble() ??
          (json[SaleItemTable.quantity] as num).toDouble(),
      quantity: (json[SaleItemTable.quantity] as num).toDouble(),
      unit: json[SaleItemTable.unit] as String,
      buyPrice: (json[SaleItemTable.buyPrice] as num).toDouble(),
      sellPrice: (json[SaleItemTable.sellPrice] as num).toDouble(),
      totalAmount: (json[SaleItemTable.totalAmount] as num).toDouble(),
      profit: (json[SaleItemTable.profit] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SaleItemTable.id: id,
      SaleItemTable.saleId: saleId,
      SaleItemTable.productId: productId,
      SaleItemTable.productName: productName,
      SaleItemTable.enteredAmount: enteredAmount,
      SaleItemTable.calculatedQuantity: calculatedQuantity,
      SaleItemTable.quantity: quantity,
      SaleItemTable.unit: unit,
      SaleItemTable.buyPrice: buyPrice,
      SaleItemTable.sellPrice: sellPrice,
      SaleItemTable.totalAmount: totalAmount,
      SaleItemTable.profit: profit,
    };
  }
}
