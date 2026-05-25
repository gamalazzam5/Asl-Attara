import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';

import '../../domain/entities/category_entity.dart';

import 'category_card.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoriesGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20.r),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 12.w,

        mainAxisSpacing: 12.h,

        childAspectRatio: .95,
      ),

      itemCount: categories.length,

      itemBuilder: (context, index) {
        final category = categories[index];

        return CategoryCard(
          category: category,

          onTap: () {
            context.push(
              RouteNames.categoryProducts,

              extra: {'id': category.id, 'name': category.title},
            );
          },
        );
      },
    );
  }
}
