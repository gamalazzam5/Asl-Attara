import 'package:aslattara/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {

  final int currentIndex;

  final Function(int)? onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.all(16.r),

      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.h,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(
          20.r,
        ),

        boxShadow: [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: Offset(
              0,
              2.h,
            ),
          ),

        ],
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,

        children: [

          _buildItem(
            icon: Icons.home,
            label: 'الرئيسية',
            index: 0,
          ),

          _buildItem(
            icon: Icons.grid_view,
            label: 'الأقسام',
            index: 1,
          ),

          _buildItem(
            icon: Icons.inventory_2_outlined,
            label: 'المنتجات',
            index: 2,
          ),

          _buildItem(
            icon: Icons.settings_outlined,
            label: 'الإعدادات',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({

    required IconData icon,
    required String label,
    required int index,

  }) {

    bool isSelected =
        currentIndex == index;

    return GestureDetector(

      onTap: () {
        onTap?.call(index);
      },

      child: Column(

        mainAxisSize:
        MainAxisSize.min,

        children: [

          Icon(
            icon,
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey,
          ),

          SizedBox(
            height: 4.h,
          ),

          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isSelected
                  ? AppColors.primaryColor
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}