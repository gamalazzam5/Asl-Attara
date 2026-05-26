import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/product_entity.dart';
import '../manger/cubits/product_cubit.dart';

class ProductActions extends StatelessWidget {
  final ProductEntity product;

  const ProductActions({super.key, required this.product});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,

          title: const Text('حذف المنتج'),
          content: Text('هل تريد حذف "${product.name}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('إلغاء'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.delete_outline),
              label: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final deleted = await context.read<ProductCubit>().deleteProduct(product);

    if (!context.mounted) return;

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف المنتج بنجاح'),
          backgroundColor: AppColors.primaryColor,
        ),
      );
      context.pop();
    }
  }

  Future<void> _editProduct(BuildContext context) async {
    final edited = await context.push<bool>(
      RouteNames.editProduct,
      extra: {'product': product, 'cubit': context.read<ProductCubit>()},
    );

    if (edited == true && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          width: double.infinity,
          onTap: () => _editProduct(context),
          text: 'تعديل المنتج',
          backgroundColor: AppColors.primaryColor,
          icon: Icons.edit_outlined,
        ),
        SizedBox(height: 12.h),
        CustomButton(
          width: double.infinity,
          onTap: () => _confirmDelete(context),
          text: 'حذف المنتج',
          backgroundColor: AppColors.errorColor,
          icon: Icons.delete_outline,
        ),
      ],
    );
  }
}
