import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/product_entity.dart';
import '../views/product_details_view.dart';
import 'product_card.dart';

class ProductsList extends StatelessWidget {
  final List<ProductEntity> products;

  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,

      separatorBuilder: (_, __) => SizedBox(height: 12.h),

      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => ProductDetailsView(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}
