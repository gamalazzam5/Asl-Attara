import 'dart:async';
import 'package:aslattara/core/constants/app_colors.dart';
import 'package:aslattara/core/constants/text_style.dart';
import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();

    navigateToDashboard();
  }

  Future<void> navigateToDashboard() async {

    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (mounted) {
      context.go(
        RouteNames.mainNavigation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F5),

      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [

            Image.asset(
              Assets.imagesLogo,
              height: 140.h,
            ),

            SizedBox(
              height: 12.h,
            ),

            Text(
              'أصل العطارة',
              style: TextStyles.text24.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),

            // SizedBox(
            //   height: 10.h,
            // ),
            //
            // Text(
            //   'تحت إدارة دكتور إياد المغربي',
            //   style: TextStyles.text14.copyWith(
            //     color: Colors.grey.shade600,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}