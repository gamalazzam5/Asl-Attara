import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/category_entity.dart';
import 'category_card.dart';

class CategoriesGrid extends StatelessWidget {

  final List<CategoryEntity> categories;

  const CategoriesGrid({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(

      padding: EdgeInsets.all(20.r),

      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: .95,

      ),

      itemCount: categories.length,

      itemBuilder: (context,index){

        return CategoryCard(
          category: categories[index],
        );
      },
    );
  }
}