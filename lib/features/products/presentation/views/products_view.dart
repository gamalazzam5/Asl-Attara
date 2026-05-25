import 'package:aslattara/core/constants/app_colors.dart';
import 'package:aslattara/core/constants/text_style.dart';
import 'package:aslattara/core/widgets/custom_search_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../manger/cubits/product_cubit.dart';
import '../manger/cubits/product_state.dart';

import '../widgets/products_list.dart';

class ProductsView extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const ProductsView({super.key, this.categoryId, this.categoryName});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    super.initState();

    context.read<ProductCubit>().loadProducts(categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final bool fromCategory = widget.categoryId != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: fromCategory
          ? AppBar(
              backgroundColor: Colors.white,

              elevation: 0,

              scrolledUnderElevation: 0,

              centerTitle: true,

              leading: IconButton(
                onPressed: () {
                  context.pop();
                },

                icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
              ),

              title: Text(
                widget.categoryName!,

                style: TextStyles.text22.copyWith(
                  fontWeight: FontWeight.bold,

                  color: AppColors.primaryColor,
                ),
              ),
            )
          : null,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),

          child: Column(
            children: [
              if (!fromCategory) ...[
                Text(
                  'أصل العطارة',

                  style: TextStyles.text22.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20.h),
              ],

              CustomSearchField(
                hintText: 'ابحث عن منتج...',

                onChanged: (value) {
                  context.read<ProductCubit>().search(value);
                },
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProductLoaded) {
                      if (state.filteredProducts.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد منتجات',

                            style: TextStyles.text16,
                          ),
                        );
                      }

                      return ProductsList(products: state.filteredProducts);
                    }

                    if (state is ProductError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
