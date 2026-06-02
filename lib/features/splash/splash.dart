import 'dart:async';

import 'package:aslattara/core/constants/app_colors.dart';
import 'package:aslattara/core/constants/text_style.dart';
import 'package:aslattara/core/routes/route_names.dart';
import 'package:aslattara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:aslattara/features/auth/presentation/cubits/auth_state.dart';
import 'package:aslattara/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.mainNavigation);
        }

        if (state is AuthUnauthenticated || state is AuthError) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.imagesLogo, height: 140.h),
              SizedBox(height: 12.h),
              Text(
                'أصل العطارة',
                style: TextStyles.text24.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
