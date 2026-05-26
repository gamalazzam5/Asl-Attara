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
        return Icons.add_circle_outline;
      case 'update':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      default:
        return Icons.history;
    }
  }

  Color get _color {
    switch (activity.action) {
      case 'add':
        return AppColors.primaryColor;
      case 'update':
        return Colors.orange;
      case 'delete':
        return AppColors.errorColor;
      default:
        return Colors.grey;
    }
  }

  String get _timeText {
    final difference = DateTime.now().difference(activity.createdAt);

    if (difference.inMinutes < 1) return 'الآن';
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
    return 'منذ ${difference.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
