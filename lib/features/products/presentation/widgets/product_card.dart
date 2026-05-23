import 'package:aslattara/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/text_style.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16.r),

      child: Card(
        elevation: 1,
        color: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),

        child: Padding(
          padding: EdgeInsets.all(16.r),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      product.name,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyles.text18.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),

                      decoration: BoxDecoration(
                        color: product.lowStock
                            ? Colors.red.shade50
                            : Colors.green.shade50,

                        borderRadius: BorderRadius.circular(20.r),

                        border: Border.all(
                          color: product.lowStock
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),

                      child: Text(
                        product.lowStock ? 'مخزون منخفض' : 'متوفر',

                        style: TextStyles.text12.copyWith(
                          color: product.lowStock ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              /// Quantity Left
              Text(
                '${product.quantity} ${product.unit}',

                style: TextStyles.text18.copyWith(
                  fontWeight: FontWeight.bold,

                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
