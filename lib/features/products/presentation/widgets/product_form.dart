import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/text_style.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_search_field.dart';

import '../../../categories/presentation/manger/cubits/category_cubit.dart';
import '../../../categories/presentation/manger/cubits/category_state.dart';

import '../../domain/entities/product_entity.dart';

import 'price_field.dart';
import 'searchable_category_dropdown.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? product;

  final String buttonText;

  /// لو بنيجي من category screen، بنبعت الـ id عشان نضبط الـ category تلقائياً
  final int? initialCategoryId;

  final Function({
  required String name,
  required String category,
  required int categoryId,      // ← أضفنا categoryId هنا
  required String unit,
  required double quantity,
  required double lowStock,
  required double buyPrice,
  required double sellPrice,
  }) onSave;

  const ProductForm({
    super.key,
    this.product,
    this.initialCategoryId,
    required this.buttonText,
    required this.onSave,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();

  final units = ['كجم', 'جرام', 'لتر', 'مل', 'قطعة'];

  late TextEditingController productController;
  late TextEditingController quantityController;
  late TextEditingController lowStockController;
  late TextEditingController buyController;
  late TextEditingController sellController;

  String? selectedCategory;
  int? selectedCategoryId;       // ← بنحفظ الـ id مش بس الاسم
  String? selectedUnit;

  @override
  void initState() {
    super.initState();

    final p = widget.product;

    productController = TextEditingController(text: p?.name);
    quantityController = TextEditingController(text: p?.quantity.toString());
    lowStockController = TextEditingController(
      text: p?.minimumStockQuantity.toString(),
    );
    buyController = TextEditingController(text: p?.buyPrice.toString());
    sellController = TextEditingController(text: p?.sellPrice.toString());

    selectedCategory = p?.categoryName;
    selectedCategoryId = p?.categoryId;
    selectedUnit = p?.unit;
  }

  @override
  void dispose() {
    productController.dispose();
    quantityController.dispose();
    lowStockController.dispose();
    buyController.dispose();
    sellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// Product Name
          Text('اسم المنتج', style: TextStyles.text16),
          SizedBox(height: 8.h),
          CustomSearchField(
            controller: productController,
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
          Text('القسم', style: TextStyles.text16),
          SizedBox(height: 8.h),

          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded) {
                // لو في initialCategoryId وما اتضبطتش الـ selectedCategory لسه
                // نضبطها من الـ categories list
                if (widget.initialCategoryId != null &&
                    selectedCategoryId == null) {
                  final match = state.categories.where(
                        (c) => c.id == widget.initialCategoryId,
                  );
                  if (match.isNotEmpty) {
                    // بعد الـ build نضبط الـ state عشان مينفعش نعمل setState جوا build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          selectedCategory = match.first.title;
                          selectedCategoryId = match.first.id;
                        });
                      }
                    });
                  }
                }

                return SearchableCategoryDropdown(
                  hintText: 'اختر القسم',
                  categories: state.categories.map((e) => e.title).toList(),
                  selectedItem: selectedCategory,
                  onSelected: (value) {
                    // لما المستخدم يختار category، بنحفظ الاسم والـ id
                    final selected = state.categories.firstWhere(
                          (c) => c.title == value,
                    );
                    setState(() {
                      selectedCategory = value;
                      selectedCategoryId = selected.id;
                    });
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),

          SizedBox(height: 16.h),

          /// Quantity
          Text('الكمية', style: TextStyles.text16),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: CustomSearchField(
                  controller: quantityController,
                  hintText: 'أدخل الكمية',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'مطلوب';
                    if (double.tryParse(value) == null) return 'رقم غير صحيح';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: SearchableCategoryDropdown(
                  hintText: 'اختر الوحدة',
                  categories: units,
                  selectedItem: selectedUnit,
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

          /// Low Stock
          Text('حد المخزون المنخفض', style: TextStyles.text16),
          SizedBox(height: 8.h),
          CustomSearchField(
            controller: lowStockController,
            hintText: 'مثال : 10',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'مطلوب';
              if (double.tryParse(value) == null) return 'رقم غير صحيح';
              return null;
            },
          ),

          SizedBox(height: 16.h),

          /// Prices
          Row(
            children: [
              Expanded(
                child: PriceField(hint: 'سعر البيع', controller: sellController),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PriceField(hint: 'سعر الشراء', controller: buyController),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          /// Save Button
          CustomButton(
            width: double.infinity,
            text: widget.buttonText,
            backgroundColor: AppColors.primaryColor,
            icon: widget.product == null ? Icons.add : Icons.edit,
            onTap: () {
              if (!formKey.currentState!.validate()) return;

              if (selectedCategory == null || selectedCategoryId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اختر القسم')),
                );
                return;
              }

              if (selectedUnit == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اختر الوحدة')),
                );
                return;
              }

              widget.onSave(
                name: productController.text.trim(),
                category: selectedCategory!,
                categoryId: selectedCategoryId!,   // ← بنبعت الـ id الحقيقي
                unit: selectedUnit!,
                quantity: double.parse(quantityController.text),
                lowStock: double.parse(lowStockController.text),
                buyPrice: double.parse(buyController.text),
                sellPrice: double.parse(sellController.text),
              );
            },
          ),
        ],
      ),
    );
  }
}