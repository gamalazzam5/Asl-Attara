import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

import '../../domain/entities/product_entity.dart';

import '../manger/cubits/product_cubit.dart';

import '../widgets/product_form.dart';

class EditProductView extends StatelessWidget {
  final ProductEntity product;

  const EditProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'تعديل المنتج',
          style: TextStyles.text18.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(20),
            child: ProductForm(
              product: product,
              buttonText: 'حفظ التعديلات',

              onSave:
                  ({
                    required name,
                    required category,
                    required categoryId,
                    required unit,
                    required quantity,
                    required lowStock,
                    required buyPrice,
                    required sellPrice,
                  }) async {
                    final updatedProduct = ProductEntity(
                      id: product.id,
                      name: name,
                      quantity: quantity,
                      unit: unit,
                      minimumStockQuantity: lowStock,
                      categoryId: categoryId,
                      categoryName: category,
                      buyPrice: buyPrice,
                      sellPrice: sellPrice,
                    );

                    final updated = await context
                        .read<ProductCubit>()
                        .updateProduct(updatedProduct);

                    if (!context.mounted) return;

                    if (updated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم حفظ التعديلات'),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                      context.pop(true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text('اسم المنتج مستخدم بالفعل'),
                        ),
                      );
                    }
                  },
            ),
          ),
        ),
      ),
    ),);
  }
}
