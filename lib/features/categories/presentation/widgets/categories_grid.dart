import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';

import '../../domain/entities/category_entity.dart';
import '../manger/cubits/category_cubit.dart';

import 'category_card.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoriesGrid({super.key, required this.categories});

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryEntity category,
  ) async {
    final itemCount = int.tryParse(category.itemCount) ?? 0;

    if (itemCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن حذف قسم يحتوي على منتجات'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,

          title: const Text('حذف القسم'),
          content: Text('هل تريد حذف قسم "${category.title}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child:  Text('إلغاء',),
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

    final deleted = await context.read<CategoryCubit>().deleteCategory(
      category,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? 'تم حذف القسم بنجاح' : 'تعذر حذف القسم'),
        backgroundColor: deleted ? AppColors.primaryColor : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: Text('لا توجد أقسام حتى الآن'));
    }

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
          onLongPress: () => _confirmDelete(context, category),

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
