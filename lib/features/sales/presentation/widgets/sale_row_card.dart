import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/services/sale_quantity_calculator.dart';

class SaleRowCard extends StatelessWidget {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final TextEditingController productSearchController;
  final TextEditingController amountController;
  final bool canRemove;
  final SaleQuantityCalculator calculator;
  final ValueChanged<ProductEntity?> onProductChanged;
  final ValueChanged<String> onProductSearchChanged;
  final ValueChanged<String> onAmountChanged;
  final VoidCallback onRemove;

  const SaleRowCard({
    super.key,
    required this.products,
    required this.selectedProduct,
    required this.productSearchController,
    required this.amountController,
    required this.canRemove,
    required this.calculator,
    required this.onProductChanged,
    required this.onProductSearchChanged,
    required this.onAmountChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final query = productSearchController.text.trim();
    final amount = double.tryParse(amountController.text) ?? 0;
    final calculatedQuantity = selectedProduct == null
        ? 0.0
        : calculator.calculateQuantity(
            enteredAmount: amount,
            sellPrice: selectedProduct!.sellPrice,
          );
    final exceedsStock =
        selectedProduct != null &&
        amount > 0 &&
        calculatedQuantity > selectedProduct!.quantity;
    final results = query.isEmpty
        ? <ProductEntity>[]
        : products
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()),
              )
              .take(8)
              .toList();
    final showResults =
        query.isNotEmpty &&
        (selectedProduct == null || selectedProduct!.name != query);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'منتج للبيع',
                    style: TextStyles.text16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                if (canRemove)
                  IconButton(
                    tooltip: 'حذف المنتج',
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.errorColor,
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: productSearchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (selectedProduct != null && value != selectedProduct!.name) {
                  onProductChanged(null);
                }
                onProductSearchChanged(value);
              },
              decoration: InputDecoration(
                labelText: 'المنتج',
                hintText: 'اكتب اسم المنتج',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: productSearchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'مسح البحث',
                        onPressed: () {
                          productSearchController.clear();
                          onProductChanged(null);
                          onProductSearchChanged('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
              ),
            ),
            if (showResults) ...[
              SizedBox(height: 8.h),
              _SearchResults(
                results: results,
                onSelected: (product) {
                  productSearchController.text = product.name;
                  productSearchController.selection = TextSelection.collapsed(
                    offset: product.name.length,
                  );
                  onProductChanged(product);
                  onProductSearchChanged(product.name);
                },
              ),
            ],
            if (selectedProduct != null) ...[
              SizedBox(height: 12.h),
              _ProductMeta(product: selectedProduct!, calculator: calculator),
            ],
            SizedBox(height: 14.h),
            TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [_MoneyInputFormatter()],
              textAlign: TextAlign.center,
              style: TextStyles.text18.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              onChanged: onAmountChanged,
              decoration: InputDecoration(
                labelText: 'المبلغ',
                hintText: '0',
                suffixText: 'جنيه',
                prefixIcon: const Icon(Icons.payments_outlined),
                errorText: exceedsStock
                    ? 'الكمية المطلوبة أكبر من المخزون المتاح'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
              ),
            ),
            SizedBox(height: 12.h),
            _QuantityPreview(
              selectedProduct: selectedProduct,
              calculatedQuantity: calculatedQuantity,
              calculator: calculator,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<ProductEntity> results;
  final ValueChanged<ProductEntity> onSelected;

  const _SearchResults({required this.results, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          'لا توجد نتائج مطابقة',
          style: TextStyles.text14.copyWith(color: Colors.grey.shade700),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 230.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: results.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final product = results[index];
          return ListTile(
            dense: true,
            title: Text(
              product.name,
              style: TextStyles.text16.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_back_ios_new, size: 16),
            onTap: () => onSelected(product),
          );
        },
      ),
    );
  }
}

class _ProductMeta extends StatelessWidget {
  final ProductEntity product;
  final SaleQuantityCalculator calculator;

  const _ProductMeta({required this.product, required this.calculator});

  @override
  Widget build(BuildContext context) {
    final maxSaleAmount = calculator.maximumSaleAmount(product);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Wrap(
        spacing: 14.w,
        runSpacing: 8.h,
        children: [
          _MetaText(
            icon: Icons.sell_outlined,
            text:
                '${product.sellPrice.toStringAsFixed(2)} جنيه / ${product.unit}',
          ),
          _MetaText(
            icon: Icons.inventory_2_outlined,
            text:
                'المتاح ${calculator.formatQuantity(product.quantity, product.unit)}',
          ),
          _MetaText(
            icon: Icons.account_balance_wallet_outlined,
            text: 'أقصى بيع ${maxSaleAmount.toStringAsFixed(2)} جنيه',
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17.r, color: AppColors.primaryColor),
        SizedBox(width: 5.w),
        Text(text, style: TextStyles.text14),
      ],
    );
  }
}

class _QuantityPreview extends StatelessWidget {
  final ProductEntity? selectedProduct;
  final double calculatedQuantity;
  final SaleQuantityCalculator calculator;

  const _QuantityPreview({
    required this.selectedProduct,
    required this.calculatedQuantity,
    required this.calculator,
  });

  @override
  Widget build(BuildContext context) {
    final hasPreview = selectedProduct != null && calculatedQuantity > 0;
    final previewText = hasPreview
        ? calculator.formatQuantity(calculatedQuantity, selectedProduct!.unit)
        : 'اختر المنتج وأدخل المبلغ';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.scale_outlined, color: AppColors.primaryColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'الكمية الناتجة',
              style: TextStyles.text14.copyWith(color: Colors.grey.shade700),
            ),
          ),
          Text(
            previewText,
            style: TextStyles.text18.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoneyInputFormatter extends TextInputFormatter {
  static final RegExp _validAmount = RegExp(r'^\d{0,8}([.]\d{0,2})?$');

  const _MoneyInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalizedText = newValue.text.replaceAll(',', '.');

    if (normalizedText.isEmpty || _validAmount.hasMatch(normalizedText)) {
      return newValue.copyWith(
        text: normalizedText,
        selection: TextSelection.collapsed(offset: normalizedText.length),
      );
    }

    return oldValue;
  }
}
