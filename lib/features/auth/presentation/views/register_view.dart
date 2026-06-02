import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../../../../core/routes/route_names.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(RouteNames.mainNavigation);
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.errorColor,
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 28.h),
                    const AuthHeader(
                      title: 'إنشاء حساب',
                      subtitle: 'أنشئ حسابا جديدا لإدارة بيانات العطارة',
                    ),
                    SizedBox(height: 32.h),
                    AuthTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: AuthValidators.email,
                    ),
                    SizedBox(height: 16.h),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: AuthValidators.password,
                    ),
                    SizedBox(height: 16.h),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور',
                      icon: Icons.lock_reset,
                      obscureText: true,
                      validator: (value) => AuthValidators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AuthPrimaryButton(
                      text: 'إنشاء الحساب',
                      isLoading: isLoading,
                      onPressed: _register,
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.go(RouteNames.login),
                      child: Text(
                        'لديك حساب بالفعل؟ تسجيل الدخول',
                        style: TextStyles.text14.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
