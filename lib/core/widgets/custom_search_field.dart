import 'package:aslattara/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;

  final TextEditingController? controller;

  final Function(String)? onChanged;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final TextInputType? keyboardType;

  final bool readOnly;

  final int? maxLines;

  final VoidCallback? onTap;

  final String? suffixText;

  final Color? backgroundColor;
  final String? Function(String?)? validator;

  const CustomSearchField({
    super.key,

    required this.hintText,

    this.controller,

    this.onChanged,

    this.prefixIcon,

    this.suffixIcon,

    this.keyboardType,

    this.readOnly = false,

    this.maxLines = 1,

    this.onTap,

    this.suffixText,

    this.backgroundColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,

      keyboardType: keyboardType,

      readOnly: readOnly,

      maxLines: maxLines,

      onTap: onTap,

      textAlign: TextAlign.right,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(color: Colors.grey.shade500),

        filled: true,

        fillColor: backgroundColor ?? const Color(0xffF7F8FA),

        suffixText: suffixText,

        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),

        prefixIcon: prefixIcon ?? const Icon(Icons.search),

        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.3),
        ),
      ),
    );
  }
}
