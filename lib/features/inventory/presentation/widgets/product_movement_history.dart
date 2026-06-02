import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/text_style.dart';
import '../cubits/inventory_cubit.dart';
import '../cubits/inventory_state.dart';
import 'inventory_movement_tile.dart';

class ProductMovementHistory extends StatefulWidget {
  final int productId;

  const ProductMovementHistory({super.key, required this.productId});

  @override
  State<ProductMovementHistory> createState() => _ProductMovementHistoryState();
}

class _ProductMovementHistoryState extends State<ProductMovementHistory> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryCubit>().loadProductMovements(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, state) {
        if (state is InventoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is InventoryMovementsLoaded) {
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                'حركة المنتج',
                style: TextStyles.text18.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              if (state.movements.isEmpty)
                const Text('لا توجد حركة مسجلة لهذا المنتج')
              else
                ...state.movements.take(8).map(InventoryMovementTile.new),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
