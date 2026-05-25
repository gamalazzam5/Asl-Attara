import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_search_field.dart';

class PriceField extends StatelessWidget {
  final String hint;

  final TextEditingController controller;

  const PriceField({super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      controller: controller,

      hintText: hint,

      keyboardType: const TextInputType.numberWithOptions(decimal: true),

      suffixText: 'ج.م',

      prefixIcon: const SizedBox(),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'السعر مطلوب';
        }

        final price = double.tryParse(value);

        if (price == null) {
          return 'أدخل رقم صحيح';
        }

        if (price <= 0) {
          return 'يجب أن يكون أكبر من 0';
        }

        return null;
      },
    );
  }
}
