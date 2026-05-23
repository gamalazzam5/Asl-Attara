import 'package:aslattara/core/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../manger/cubits/product_cubit.dart';
import '../manger/cubits/product_state.dart';

import '../widgets/products_list.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    super.initState();

    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.r),

          child: Column(
            children: [
              Text(
                'أصل العطارة',

                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.h),

              CustomSearchField(
                hintText: 'ابحث عن منتج...',

                onChanged: (value){

                  context
                      .read<ProductCubit>()
                      .search(value);

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
