import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/manger/cubits/category_state.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_search_field.dart';

import '../widgets/price_field.dart';
import '../widgets/searchable_category_dropdown.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;

  String? selectedUnit;

  final units = ['كجم', 'جرام', 'لتر', 'مل', 'قطعة'];

  final productNameController = TextEditingController();

  final quantityController = TextEditingController();

  final lowStockController = TextEditingController();

  final buyController = TextEditingController();

  final sellController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();

    quantityController.dispose();

    lowStockController.dispose();

    buyController.dispose();

    sellController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,

        scrolledUnderElevation: 0,

        centerTitle: true,

        title: Text(
          'إضافة منتج جديد',

          style: TextStyles.text18.copyWith(
            fontWeight: FontWeight.bold,

            color: AppColors.primaryColor,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// Product name
              Text(
                'اسم المنتج',

                style: TextStyles.text16.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 8.h),

              CustomSearchField(
                controller: productNameController,

                hintText: 'أدخل اسم المنتج',

                prefixIcon: const SizedBox(),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'اسم المنتج مطلوب';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16.h),

              /// Category
              Text(
                'القسم',

                style: TextStyles.text16.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 8.h),

              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return SearchableCategoryDropdown(
                      hintText: 'اختر القسم',

                      searchHint: 'ابحث عن القسم',

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'القسم مطلوب';
                        }

                        return null;
                      },

                      categories: state.categories
                          .map((category) => category.title)
                          .toList(),

                      selectedItem: selectedCategory,

                      onSelected: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),

              SizedBox(height: 16.h),

              /// Quantity
              Text(
                'الكمية',

                style: TextStyles.text16.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                      controller: quantityController,

                      hintText: 'أدخل الكمية',

                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),

                      prefixIcon: const SizedBox(),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'مطلوبة';
                        }

                        return null;
                      },
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: SearchableCategoryDropdown(
                      hintText: 'اختر الوحدة',

                      searchHint: 'ابحث عن وحدة',

                      categories: units,

                      selectedItem: selectedUnit,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'مطلوبة';
                        }

                        return null;
                      },

                      onSelected: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              /// Minimum stock quantity
              Text(
                'حد المخزون المنخفض',

                style: TextStyles.text16.copyWith(fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 8.h),

              CustomSearchField(
                controller: lowStockController,

                hintText: 'مثال: 10',

                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                prefixIcon: const SizedBox(),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'مطلوب';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16.h),

              /// Prices
              Row(
                children: [
                  Expanded(
                    child: PriceField(
                      hint: 'سعر البيع',

                      controller: sellController,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'مطلوب';
                        }

                        return null;
                      },
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: PriceField(
                      hint: 'سعر الشراء',

                      controller: buyController,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'مطلوب';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              CustomButton(
                width: double.infinity,

                text: 'حفظ المنتج',

                backgroundColor: AppColors.primaryColor,

                onTap: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
//TODO : add product to database
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
