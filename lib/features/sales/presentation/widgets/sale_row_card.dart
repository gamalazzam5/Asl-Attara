import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../products/domain/entities/product_entity.dart';

class SaleRowCard extends StatelessWidget {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final TextEditingController productSearchController;
  final TextEditingController quantityController;
  final bool canRemove;
  final ValueChanged<ProductEntity?> onProductChanged;
  final ValueChanged<String> onQuantityChanged;
  final VoidCallback onRemove;

  const SaleRowCard({
    super.key,
    required this.products,
    required this.selectedProduct,
    required this.productSearchController,
    required this.quantityController,
    required this.canRemove,
    required this.onProductChanged,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final rowTotal = selectedProduct == null
        ? 0
        : selectedProduct!.sellPrice *
              (double.tryParse(quantityController.text) ?? 0);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownMenu<ProductEntity>(
                  controller: productSearchController,
                  initialSelection: selectedProduct,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,

                  hintText: 'ابحث عن المنتج',
                  label: const Text('المنتج'),

                  leadingIcon: const Icon(Icons.search, color: Colors.black87),

                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFF5F5F5)),
                    elevation: WidgetStatePropertyAll(10),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

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

                  dropdownMenuEntries: products.map((product) {
                    return DropdownMenuEntry(
                      value: product,
                      label:
                          '${product.name} - متاح ${product.quantity.toStringAsFixed(2)} ${product.unit}',
                    );
                  }).toList(),

                  onSelected: onProductChanged,
                ),
              ),
              if (canRemove) ...[
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.errorColor,
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [_QuantityInputFormatter()],
                  textAlign: TextAlign.center,
                  style: TextStyles.text18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  onChanged: onQuantityChanged,
                  decoration: InputDecoration(
                    labelText: 'الكمية',
                    hintText: '0',
                    suffixText: selectedProduct?.unit,
                    prefixIcon: const Icon(Icons.scale_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    helperText: selectedProduct == null
                        ? 'اختار المنتج أولا'
                        : 'المتاح ${selectedProduct!.quantity.toStringAsFixed(2)} ${selectedProduct!.unit}',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '${rowTotal.toStringAsFixed(2)} جنيه',
                  textAlign: TextAlign.end,
                  style: TextStyles.text16.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityInputFormatter extends TextInputFormatter {
  static final RegExp _validQuantity = RegExp(r'^\d{0,7}([.]\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalizedText = newValue.text.replaceAll(',', '.');

    if (normalizedText.isEmpty || _validQuantity.hasMatch(normalizedText)) {
      return newValue.copyWith(
        text: normalizedText,
        selection: TextSelection.collapsed(offset: normalizedText.length),
      );
    }

    return oldValue;
  }
}
