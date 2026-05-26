import 'package:aslattara/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/text_style.dart';
import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/manger/cubits/product_state.dart';
import '../../../products/presentation/widgets/products_list.dart';

class LowStockView extends StatefulWidget {
  const LowStockView({super.key});

  @override
  State<LowStockView> createState() => _LowStockViewState();
}

class _LowStockViewState extends State<LowStockView> {
  @override
  void initState() {
    super.initState();

    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: Text(
          'المنتجات منخفضة المخزون',
          style: TextStyles.text18.copyWith(
            fontWeight: .bold,
            color: AppColors.errorColor,
          ),
        ),
      ),

      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            final lowStockProducts = state.products
                .where((product) => product.lowStock)
                .toList();

            if (lowStockProducts.isEmpty) {
              return const Center(child: Text('لا يوجد منتجات منخفضة المخزون'));
            }

            return ProductsList(products: lowStockProducts);
          }

          return const SizedBox();
        },
      ),
    );
  }
}
