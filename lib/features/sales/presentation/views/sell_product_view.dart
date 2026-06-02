import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/manger/cubits/product_state.dart';
import '../../domain/repositories/sales_repository.dart';
import '../cubits/sales_cubit.dart';
import '../cubits/sales_state.dart';
import '../widgets/sale_row_card.dart';

class SellProductView extends StatefulWidget {
  const SellProductView({super.key});

  @override
  State<SellProductView> createState() => _SellProductViewState();
}

class _SellProductViewState extends State<SellProductView> {
  final List<_SaleRowData> _rows = [_SaleRowData()];

  double get _total {
    return _rows.fold(0, (sum, row) {
      final product = row.product;
      final quantity = double.tryParse(row.quantityController.text) ?? 0;
      return sum + (product == null ? 0 : product.sellPrice * quantity);
    });
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.quantityController.dispose();
      row.productSearchController.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() => _rows.add(_SaleRowData()));
  }

  void _removeRow(int index) {
    if (_rows.length == 1) return;

    setState(() {
      final row = _rows.removeAt(index);
      row.quantityController.dispose();
      row.productSearchController.dispose();
    });
  }

  void _saveSale() {
    final items = <SaleDraftItem>[];

    for (final row in _rows) {
      final product = row.product;
      final quantity = double.tryParse(row.quantityController.text);

      if (product == null || quantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.errorColor,
            content: Text('اختر المنتج وأدخل الكمية لكل صف'),
          ),
        );
        return;
      }

      items.add(SaleDraftItem(product: product, quantity: quantity));
    }

    context.read<SalesCubit>().saveSale(items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
        title: Text(
          'عملية بيع',
          style: TextStyles.text22.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<SalesCubit, SalesState>(
        listener: (context, state) {
          if (state is SaleSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.primaryColor,
                content: Text('تم حفظ عملية البيع بنجاح'),
              ),
            );
            context.pop();
          }

          if (state is SalesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.errorColor,
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, salesState) {
          return BlocBuilder<ProductCubit, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (productState is! ProductLoaded) {
                return const Center(child: Text('لا توجد منتجات متاحة للبيع'));
              }

              final products = productState.products
                  .where((product) => product.quantity > 0)
                  .toList();

              if (products.isEmpty) {
                return const Center(child: Text('لا توجد منتجات في المخزون'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(20.r),
                      itemCount: _rows.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return SaleRowCard(
                          products: products,
                          selectedProduct: _rows[index].product,
                          productSearchController:
                              _rows[index].productSearchController,
                          quantityController: _rows[index].quantityController,
                          canRemove: _rows.length > 1,
                          onProductChanged: (product) {
                            setState(() => _rows[index].product = product);
                          },
                          onQuantityChanged: (_) => setState(() {}),
                          onRemove: () => _removeRow(index),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12.r,
                          offset: Offset(0, -2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'الإجمالي',
                                style: TextStyles.text18.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${_total.toStringAsFixed(2)} جنيه',
                              style: TextStyles.text20.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _addRow,
                                icon: const Icon(Icons.add,color: Colors.black,),
                                label: const Text('إضافة منتج',style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: salesState is SalesLoading
                                    ? null
                                    : _saveSale,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                icon: salesState is SalesLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                label: const Text(
                                  'حفظ البيع',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SaleRowData {
  ProductEntity? product;
  final TextEditingController productSearchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
}
