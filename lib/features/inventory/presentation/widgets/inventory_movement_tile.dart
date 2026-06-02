import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../domain/entities/inventory_log_entity.dart';

class InventoryMovementTile extends StatelessWidget {
  final InventoryLogEntity movement;

  const InventoryMovementTile(this.movement, {super.key});

  @override
  Widget build(BuildContext context) {
    final isPositive = movement.changeQuantity > 0;
    final quantityText =
        '${isPositive ? '+' : ''}${movement.changeQuantity.toStringAsFixed(2)}';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isPositive
                ? const Color(0xFFE7F5ED)
                : Colors.red.shade50,
            child: Icon(
              isPositive ? Icons.add : Icons.remove,
              color: isPositive ? AppColors.primaryColor : AppColors.errorColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.description,
                  style: TextStyles.text14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatDate(movement.createdAt),
                  style: TextStyles.text12.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            quantityText,
            style: TextStyles.text18.copyWith(
              color: isPositive ? AppColors.primaryColor : AppColors.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
