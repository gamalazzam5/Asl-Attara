import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../auth/presentation/widgets/auth_logout_button.dart';
import '../manger/cubits/settings_cubit.dart';
import '../manger/cubits/settings_state.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadBackupMetadata();
  }

  Future<void> _confirmRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          title: const Text('استعادة النسخة الاحتياطية'),
          content: const Text(
            'سيتم حذف البيانات الحالية واستبدالها بالنسخة المحفوظة على Firebase. استخدم هذا الخيار فقط عند فقدان التطبيق أو تلف قاعدة البيانات.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'استبدال البيانات',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      context.read<SettingsCubit>().restoreBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) {
            return previous.successMessage != current.successMessage ||
                previous.errorMessage != current.errorMessage;
          },
          listener: (context, state) {
            final message = state.successMessage ?? state.errorMessage;
            if (message == null) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: state.successMessage != null
                    ? AppColors.primaryColor
                    : AppColors.errorColor,
                content: Text(message),
              ),
            );
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'الإعدادات',
                    textAlign: TextAlign.center,
                    style: TextStyles.text22.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  const _AccountPanel(),
                  SizedBox(height: 20.h),
                  _BackupPanel(state: state),
                  SizedBox(height: 20.h),
                  _DangerZone(state: state, onRestorePressed: _confirmRestore),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AccountPanel extends StatelessWidget {
  const _AccountPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE7E4D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primaryColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'الحساب',
                  style: TextStyles.text18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const AuthLogoutButton(),
        ],
      ),
    );
  }
}

class _BackupPanel extends StatelessWidget {
  final SettingsState state;

  const _BackupPanel({required this.state});

  @override
  Widget build(BuildContext context) {
    final isUploading =
        state.isLoading && state.action == SettingsAction.upload;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF7),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFD7E8DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_upload_outlined, color: AppColors.primaryColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'النسخ الاحتياطي',
                  style: TextStyles.text18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _BackupSummary(state: state),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 13.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: state.isLoading
                ? null
                : () => context.read<SettingsCubit>().uploadBackup(),
            icon: isUploading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync, color: Colors.white),
            label: Text(
              isUploading ? 'جاري الرفع...' : 'رفع نسخة إلى Firebase',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  final SettingsState state;
  final VoidCallback onRestorePressed;

  const _DangerZone({required this.state, required this.onRestorePressed});

  @override
  Widget build(BuildContext context) {
    final isRestoring =
        state.isLoading && state.action == SettingsAction.restore;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF4C7C7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.errorColor,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'منطقة الخطر',
                  style: TextStyles.text18.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'استبدال قاعدة البيانات الحالية يستخدم فقط عند فقدان الهاتف، حذف التطبيق، أو تلف قاعدة البيانات.',
            style: TextStyles.text14.copyWith(color: const Color(0xFF6F2B2B)),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.errorColor),
              padding: EdgeInsets.symmetric(vertical: 13.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: state.isLoading ? null : onRestorePressed,
            icon: isRestoring
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.errorColor,
                    ),
                  )
                : const Icon(Icons.restore, color: AppColors.errorColor),
            label: Text(
              isRestoring ? 'جاري الاستعادة...' : 'استبدال البيانات الحالية',
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupSummary extends StatelessWidget {
  final SettingsState state;

  const _BackupSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.action == SettingsAction.none) {
      return const Center(child: CircularProgressIndicator());
    }

    final metadata = state.metadata;

    if (metadata == null) {
      return Text(
        'لا توجد نسخة احتياطية محفوظة حتى الآن.',
        style: TextStyles.text14.copyWith(color: Colors.black54),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoRow(
          icon: Icons.schedule,
          label: 'آخر نسخة',
          value: _formatDate(metadata.uploadedAt),
        ),
        SizedBox(height: 8.h),
        _InfoRow(
          icon: Icons.category_outlined,
          label: 'الأقسام',
          value: metadata.categoriesCount.toString(),
        ),
        SizedBox(height: 8.h),
        _InfoRow(
          icon: Icons.inventory_2_outlined,
          label: 'المنتجات',
          value: metadata.productsCount.toString(),
        ),
        SizedBox(height: 8.h),
        _InfoRow(
          icon: Icons.history,
          label: 'السجل',
          value: metadata.activitiesCount.toString(),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primaryColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyles.text14.copyWith(color: Colors.black54),
          ),
        ),
        Text(
          value,
          style: TextStyles.text14.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
