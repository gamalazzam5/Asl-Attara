import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;

  final TextEditingController? controller;

  final Function(String)? onChanged;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  const CustomSearchField({
    super.key,

    required this.hintText,

    this.controller,

    this.onChanged,

    this.prefixIcon,

    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: onChanged,

      textAlign: TextAlign.right,

      decoration: InputDecoration(
        hintText: hintText,

        filled: true,

        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(vertical: 16.h),

        prefixIcon: prefixIcon ?? const Icon(Icons.search),

        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
