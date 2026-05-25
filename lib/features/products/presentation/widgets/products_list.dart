import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,

      separatorBuilder: (_, __) => SizedBox(height: 12.h),

      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],

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
