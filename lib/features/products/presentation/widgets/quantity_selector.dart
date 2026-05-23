import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;

  final VoidCallback onAdd;

  final VoidCallback onRemove;

  const QuantitySelector({
    super.key,

    required this.quantity,

    required this.onAdd,

    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),

      decoration: BoxDecoration(
        border: Border.all(),

        borderRadius: BorderRadius.circular(12.r),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          IconButton(onPressed: onRemove, icon: const Icon(Icons.remove)),

          Text('$quantity'),

          IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
