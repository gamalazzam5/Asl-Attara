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
import '../../domain/services/sale_quantity_calculator.dart';
import '../cubits/sales_cubit.dart';
import '../cubits/sales_state.dart';
import '../widgets/sale_row_card.dart';

class SellProductView extends StatefulWidget {
  const SellProductView({super.key});

  @override
  State<SellProductView> createState() => _SellProductViewState();
}

class _SellProductViewState extends State<SellProductView> {
  final SaleQuantityCalculator _calculator = const SaleQuantityCalculator();
  final List<_SaleRowData> _rows = [_SaleRowData()];

  double get _total {
    return _rows.fold(0, (sum, row) {
      return sum + (double.tryParse(row.amountController.text) ?? 0);
    });
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.amountController.dispose();
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
      row.amountController.dispose();
      row.productSearchController.dispose();
    });
  }

  void _saveSale() {
    final items = <SaleDraftItem>[];

    for (final row in _rows) {
      final product = row.product;
      final enteredAmount = double.tryParse(row.amountController.text);

      if (product == null || enteredAmount == null || enteredAmount <= 0) {
        _showError('اختر المنتج وأدخل مبلغ البيع لكل صف');
        return;
      }

      final calculatedQuantity = _calculator.calculateQuantity(
        enteredAmount: enteredAmount,
        sellPrice: product.sellPrice,
      );

      if (calculatedQuantity > product.quantity) {
        _showError('الكمية المطلوبة أكبر من المخزون المتاح');
        return;
      }

      items.add(
        SaleDraftItem(
          product: product,
          enteredAmount: enteredAmount,
          calculatedQuantity: calculatedQuantity,
        ),
      );
    }

    context.read<SalesCubit>().saveSale(items);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.errorColor,
        content: Text(message, textDirection: TextDirection.rtl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAF7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAFAF7),
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
                  content: Text(
                    'تم حفظ عملية البيع بنجاح',
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );
              context.pop();
            }

            if (state is SalesError) {
              _showError(state.message);
            }
          },
          builder: (context, salesState) {
            return BlocBuilder<ProductCubit, ProductState>(
              builder: (context, productState) {
                if (productState is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productState is! ProductLoaded) {
                  return _EmptySaleState(
                    icon: Icons.inventory_2_outlined,
                    title: 'لا توجد منتجات متاحة للبيع',
                    subtitle: 'أضف منتجات للمخزون ثم ارجع لتسجيل البيع.',
                  );
                }

                final products = productState.products
                    .where((product) => product.quantity > 0)
                    .toList();

                if (products.isEmpty) {
                  return _EmptySaleState(
                    icon: Icons.remove_shopping_cart_outlined,
                    title: 'لا توجد منتجات في المخزون',
                    subtitle: 'كل المنتجات الحالية نفدت أو كميتها صفر.',
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                        itemCount: _rows.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final row = _rows[index];

                          return SaleRowCard(
                            products: products,
                            selectedProduct: row.product,
                            productSearchController:
                                row.productSearchController,
                            amountController: row.amountController,
                            canRemove: _rows.length > 1,
                            calculator: _calculator,
                            onProductChanged: (product) {
                              setState(() => row.product = product);
                            },
                            onProductSearchChanged: (_) => setState(() {}),
                            onAmountChanged: (_) => setState(() {}),
                            onRemove: () => _removeRow(index),
                          );
                        },
                      ),
                    ),
                    _SaleSummaryBar(
                      total: _total,
                      isSaving: salesState is SalesLoading,
                      onAddRow: _addRow,
                      onSave: _saveSale,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SaleSummaryBar extends StatelessWidget {
  final double total;
  final bool isSaving;
  final VoidCallback onAddRow;
  final VoidCallback onSave;

  const _SaleSummaryBar({
    required this.total,
    required this.isSaving,
    required this.onAddRow,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  '${total.toStringAsFixed(2)} جنيه',
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
                    onPressed: isSaving ? null : onAddRow,
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text(
                      'إضافة منتج',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: const Text('حفظ البيع'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySaleState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptySaleState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54.r, color: Colors.grey.shade500),
            SizedBox(height: 14.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.text18.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyles.text14.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleRowData {
  ProductEntity? product;
  final TextEditingController productSearchController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
}
