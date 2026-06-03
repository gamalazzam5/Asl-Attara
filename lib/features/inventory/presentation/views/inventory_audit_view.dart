import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/utils/quantity_formatter.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/manger/cubits/product_cubit.dart';
import '../../../products/presentation/manger/cubits/product_state.dart';
import '../cubits/inventory_cubit.dart';
import '../cubits/inventory_state.dart';
import '../widgets/inventory_movement_tile.dart';

class InventoryAuditView extends StatefulWidget {
  const InventoryAuditView({super.key});

  @override
  State<InventoryAuditView> createState() => _InventoryAuditViewState();
}

class _InventoryAuditViewState extends State<InventoryAuditView> {
  ProductEntity? _selectedProduct;
  final TextEditingController _productSearchController =
      TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _productSearchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_fromDate ?? now) : (_toDate ?? now),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    setState(() {
      if (isFrom) {
        _fromDate = date;
      } else {
        _toDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
      }
    });
  }

  void _runAudit() {
    final product = _selectedProduct;
    final from = _fromDate;
    final to = _toDate;

    if (product == null || from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.errorColor,
          content: Text('اختر المنتج والفترة أولا'),
        ),
      );
      return;
    }

    if (from.isAfter(to)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.errorColor,
          content: Text('تاريخ البداية يجب أن يكون قبل تاريخ النهاية'),
        ),
      );
      return;
    }

    context.read<InventoryCubit>().auditProduct(
      productId: product.id,
      from: from,
      to: to,
      currentQuantity: product.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
            'جرد المخزون',
            style: TextStyles.text22.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, productState) {
            if (productState is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productState is! ProductLoaded ||
                productState.products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات للجرد'));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownMenu<ProductEntity>(
                    controller: _productSearchController,
                    initialSelection: _selectedProduct,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    expandedInsets: EdgeInsets.zero,
                    hintText: 'ابحث عن المنتج',
                    menuStyle: MenuStyle(
                      backgroundColor: const WidgetStatePropertyAll(
                        Color(0xFFF5F5F5),
                      ),
                      elevation: const WidgetStatePropertyAll(10),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    label: const Text('اختر المنتج'),
                    leadingIcon: const Icon(Icons.search),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    dropdownMenuEntries: productState.products.map((product) {
                      return DropdownMenuEntry(
                        value: product,
                        label:
                            '${product.name} - ${QuantityFormatter.format(product.quantity, product.unit)}',
                      );
                    }).toList(),
                    onSelected: (product) {
                      setState(() => _selectedProduct = product);
                    },
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(isFrom: true),
                          icon: const Icon(
                            Icons.date_range,
                            color: Colors.black,
                          ),
                          label: Text(
                            _fromDate == null
                                ? 'من تاريخ'
                                : _formatDate(_fromDate!),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(isFrom: false),
                          icon: const Icon(Icons.event, color: Colors.black),
                          label: Text(
                            _toDate == null
                                ? 'إلى تاريخ'
                                : _formatDate(_toDate!),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: _runAudit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    icon: const Icon(Icons.fact_check, color: Colors.white),
                    label: const Text(
                      'تنفيذ الجرد',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<InventoryCubit, InventoryState>(
                    builder: (context, state) {
                      if (state is InventoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is InventoryError) {
                        return Center(child: Text(state.message));
                      }

                      if (state is! InventoryAuditLoaded) {
                        return const SizedBox();
                      }

                      final audit = state.audit;
                      final selectedUnit = _selectedProduct?.unit ?? '';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _AuditCard(
                                title: 'رصيد البداية',
                                value: QuantityFormatter.format(
                                  audit.openingQuantity,
                                  selectedUnit,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _AuditCard(
                                title: 'المباع',
                                value: QuantityFormatter.format(
                                  audit.soldQuantity,
                                  selectedUnit,
                                ),
                                isAlert: true,
                              ),
                              SizedBox(width: 8.w),
                              _AuditCard(
                                title: 'الحالي',
                                value: QuantityFormatter.format(
                                  audit.currentQuantity,
                                  selectedUnit,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'سجل الحركة',
                            style: TextStyles.text18.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (audit.movements.isEmpty)
                            const Center(
                              child: Text('لا توجد حركات في هذه الفترة'),
                            )
                          else
                            ...audit.movements.map(
                              (movement) => InventoryMovementTile(
                                movement,
                                unit: selectedUnit,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

class _AuditCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isAlert;

  const _AuditCard({
    required this.title,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isAlert ? Colors.red.shade50 : const Color(0xFFF5FAF7),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyles.text12),
            SizedBox(height: 6.h),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyles.text18.copyWith(
                color: isAlert ? AppColors.errorColor : AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
