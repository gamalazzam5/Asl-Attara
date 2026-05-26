import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';

import '../../domain/entities/product_entity.dart';
import '../manger/cubits/product_cubit.dart';
import 'product_card.dart';

class ProductsList extends StatelessWidget {
  final List<ProductEntity> products;
  final ProductCubit? categoryProductCubit;

  const ProductsList({
    super.key,
    required this.products,
    this.categoryProductCubit,
  });

  Future<void> _confirmDelete(
    BuildContext context,
    ProductEntity product,
  ) async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,

      separatorBuilder: (context, index) => SizedBox(height: 12.h),

      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onLongPress: () => _confirmDelete(context, products[index]),

          onTap: () {
            context.push(
              RouteNames.productDetails,
              extra: {
                'product': products[index],
                if (categoryProductCubit != null) 'cubit': categoryProductCubit,
              },
            );
          },
        );
      },
    );
  }
}
