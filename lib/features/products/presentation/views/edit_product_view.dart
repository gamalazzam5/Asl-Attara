import 'package:aslattara/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/text_style.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_form.dart';

class EditProductView extends StatelessWidget {
  final ProductEntity product;

  const EditProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text('تعديل المنتج',style: TextStyles.text18.copyWith(color: AppColors.primaryColor,fontWeight: .bold),), backgroundColor: Colors.white,
      elevation: 0, scrolledUnderElevation: 0,),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ProductForm(
          product: product,

          buttonText: 'حفظ التعديلات',

          onSave:
              ({
                required name,
                required category,
                required unit,
                required quantity,
                required lowStock,
                required buyPrice,
                required sellPrice,
              }) {
                // update product cubit
              },
        ),
      ),
    );
  }
}
