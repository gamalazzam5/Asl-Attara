import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../domain/entities/activity_log_entity.dart';

class ActivityTile extends StatelessWidget {
  final ActivityLogEntity activity;

  const ActivityTile({super.key, required this.activity});

  IconData get _icon {
    switch (activity.action) {
      case 'add':
      case 'product_added':
      case 'stock_added':
        return Icons.add_circle_outline;
      case 'update':
      case 'product_edited':
      case 'inventory_updated':
        return Icons.edit_outlined;
      case 'delete':
      case 'product_deleted':
        return Icons.delete_outline;
      case 'sale_created':
        return Icons.point_of_sale_outlined;
      case 'sync_completed':
        return Icons.cloud_done_outlined;
      case 'restore_completed':
        return Icons.restore_outlined;
      default:
        return Icons.history;
    }
  }

  Color get _color {
    switch (activity.action) {
      case 'add':
      case 'product_added':
      case 'stock_added':
      case 'sale_created':
      case 'sync_completed':
      case 'restore_completed':
        return AppColors.primaryColor;
      case 'update':
      case 'product_edited':
      case 'inventory_updated':
        return Colors.orange;
      case 'delete':
      case 'product_deleted':
        return AppColors.errorColor;
      default:
        return Colors.grey;
    }
  }

  String get _timeText {
    final difference = DateTime.now().difference(activity.createdAt);

    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
    if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    }
    return 'منذ ${difference.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: _color.withValues(alpha: .12),
              child: Icon(_icon, color: _color, size: 22.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.text16.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _timeText,
                    style: TextStyles.text12.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
