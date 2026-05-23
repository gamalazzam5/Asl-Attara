import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

import '../../domain/entities/product_entity.dart';

import '../widgets/info_card.dart';
import '../widgets/product_actions.dart';
import '../widgets/product_image_avatar.dart';
import '../widgets/quantity_card.dart';
import '../widgets/stock_status_badge.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        centerTitle: true,

        title: Text(
          'تفاصيل المنتج',

          style: TextStyles.text22.copyWith(
            fontWeight: FontWeight.bold,

            color: AppColors.primaryColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),

        child: Column(
          children: [
            const ProductImageAvatar(),

            SizedBox(height: 20.h),

            Text(
              product.name,

              style: TextStyles.text24.copyWith(
                fontWeight: FontWeight.bold,

                color: AppColors.primaryColor,
              ),
            ),

            SizedBox(height: 10.h),

            if (product.lowStock) const StockStatusBadge(),

            SizedBox(height: 25.h),

            QuantityCard(quantity: product.quantity, unit: product.unit),

            SizedBox(height: 20.h),

            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,

              children: [
                infoCard(
                  context,
                  title: 'التصنيف',
                  value: product.categoryName,
                  icon: Icons.category,
                ),

                infoCard(
                  context,
                  title: 'سعر الشراء',
                  value: '${product.buyPrice} جنيه',
                  icon: Icons.money,
                ),

                infoCard(
                  context,
                  title: 'سعر البيع',
                  value: '${product.sellPrice} جنيه',
                  icon: Icons.sell,
                ),
              ],
            ),

            SizedBox(height: 30.h),

            const ProductActions(),
          ],
        ),
      ),
    );
  }
}
