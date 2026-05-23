import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_search_field.dart';

class PriceField extends StatelessWidget {
  final String hint;

  final TextEditingController controller;

  final String? Function(String?)? validator;

  const PriceField({
    super.key,

    required this.hint,

    required this.controller,

    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSearchField(
      controller: controller,

      hintText: hint,

      keyboardType: TextInputType.number,

      suffixText: 'ج.م',

      prefixIcon: const SizedBox(),

      validator: validator,
    );
  }
}
