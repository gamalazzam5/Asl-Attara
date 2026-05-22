import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../manger/cubits/category_cubit.dart';
import '../manger/cubits/category_state.dart';
import '../widgets/categories_grid.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    super.initState();

    context.read<CategoryCubit>().loadCategories();
  }

  void addCategory() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("إضافة قسم جديد")));

    // later:
    // showDialog(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: addCategory,

        child: Icon(Icons.add, size: 28.r, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryLoaded) {
              return Padding(
                padding: EdgeInsets.all(20.r),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'الأقسام',

                      style: TextStyles.text24.copyWith(
                        fontWeight: FontWeight.bold,

                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Expanded(
                      child: CategoriesGrid(categories: state.categories),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoryError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
