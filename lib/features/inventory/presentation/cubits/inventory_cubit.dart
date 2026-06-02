import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/audit_product_use_case.dart';
import '../../domain/usecases/get_product_movements_use_case.dart';
import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetProductMovementsUseCase getProductMovementsUseCase;
  final AuditProductUseCase auditProductUseCase;

  InventoryCubit(this.getProductMovementsUseCase, this.auditProductUseCase)
    : super(const InventoryInitial());

  Future<void> loadProductMovements(int productId) async {
    emit(const InventoryLoading());

    try {
      final movements = await getProductMovementsUseCase(productId);
      emit(InventoryMovementsLoaded(movements));
    } catch (e) {
      emit(const InventoryError('تعذر تحميل حركة المنتج'));
    }
  }

  Future<void> auditProduct({
    required int productId,
    required DateTime from,
    required DateTime to,
    required double currentQuantity,
  }) async {
    emit(const InventoryLoading());

    try {
      final audit = await auditProductUseCase(
        productId: productId,
        from: from,
        to: to,
        currentQuantity: currentQuantity,
      );
      emit(InventoryAuditLoaded(audit));
    } catch (e) {
      emit(const InventoryError('تعذر تنفيذ الجرد'));
    }
  }
}
