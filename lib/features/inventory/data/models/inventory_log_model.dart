import '../../../../core/database/tables/inventory_log_table.dart';
import '../../domain/entities/inventory_log_entity.dart';

class InventoryLogModel extends InventoryLogEntity {
  const InventoryLogModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.changeQuantity,
    required super.quantityBefore,
    required super.quantityAfter,
    required super.type,
    required super.description,
    required super.createdAt,
  });

  factory InventoryLogModel.fromJson(Map<String, dynamic> json) {
    return InventoryLogModel(
      id: json[InventoryLogTable.id] as int,
      productId: json[InventoryLogTable.productId] as int,
      productName: json[InventoryLogTable.productName] as String,
      changeQuantity: (json[InventoryLogTable.changeQuantity] as num)
          .toDouble(),
      quantityBefore: (json[InventoryLogTable.quantityBefore] as num)
          .toDouble(),
      quantityAfter: (json[InventoryLogTable.quantityAfter] as num).toDouble(),
      type: json[InventoryLogTable.type] as String,
      description: json[InventoryLogTable.description] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json[InventoryLogTable.createdAt] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      InventoryLogTable.id: id,
      InventoryLogTable.productId: productId,
      InventoryLogTable.productName: productName,
      InventoryLogTable.changeQuantity: changeQuantity,
      InventoryLogTable.quantityBefore: quantityBefore,
      InventoryLogTable.quantityAfter: quantityAfter,
      InventoryLogTable.type: type,
      InventoryLogTable.description: description,
      InventoryLogTable.createdAt: createdAt.millisecondsSinceEpoch,
    };
  }
}
