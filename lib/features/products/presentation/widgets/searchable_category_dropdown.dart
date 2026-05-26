import 'package:aslattara/core/constants/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchableCategoryDropdown extends StatelessWidget {
  final List<String> categories;

  final String? selectedItem;

  final Function(String?) onSelected;

  final String hintText;

  final String searchHint;
  final String? Function(String?)? validator;

  const SearchableCategoryDropdown({
    super.key,

    required this.categories,

    required this.onSelected,

    required this.hintText,

    this.searchHint = 'ابحث...',

    this.selectedItem,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (filter, props) => categories,

      selectedItem: selectedItem,
      validator: validator,
      onSelected: onSelected,

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: hintText,

          filled: true,

          fillColor: const Color(0xffF7F8FA),

          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),

            borderSide: BorderSide(color: Colors.grey.shade200),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),

            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),

      popupProps: PopupProps.menu(
        showSearchBox: true,

        fit: FlexFit.loose,

        menuProps: MenuProps(
          backgroundColor: Colors.white,

          elevation: 4,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),

        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHint,

            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
