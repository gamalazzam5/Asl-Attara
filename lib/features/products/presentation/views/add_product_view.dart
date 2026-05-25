import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

import '../../domain/entities/product_entity.dart';

import '../manger/cubits/product_cubit.dart';

import '../widgets/product_form.dart';

class AddProductView extends StatelessWidget {
  final int? categoryId;

  const AddProductView({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'إضافة منتج',
          style: TextStyles.text18.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ProductForm(
          buttonText: 'حفظ المنتج',
          initialCategoryId: categoryId,

          onSave: ({
            required name,
            required category,
            required categoryId,
            required unit,
            required quantity,
            required lowStock,
            required buyPrice,
            required sellPrice,
          }) async {
            final product = ProductEntity(
              id: DateTime.now().millisecondsSinceEpoch,
              name: name,
              quantity: quantity,
              unit: unit,
              minimumStockQuantity: lowStock,
              categoryId: categoryId,   // ← الـ id الحقيقي مش 0
              categoryName: category,
              buyPrice: buyPrice,
              sellPrice: sellPrice,
            );

            final added = await context.read<ProductCubit>().addProduct(product);

            if (!context.mounted) return;

            if (added) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إضافة المنتج بنجاح')),
              );
              context.pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text('المنتج موجود بالفعل'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}