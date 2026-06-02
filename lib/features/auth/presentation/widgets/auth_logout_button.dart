import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class AuthLogoutButton extends StatelessWidget {
  const AuthLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthUnauthenticated || current is AuthError,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(RouteNames.login);
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

        return OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () => context.read<AuthCubit>().logout(),
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout, color: AppColors.errorColor),
          label: const Text(
            'تسجيل الخروج',
            style: TextStyle(color: AppColors.errorColor),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.errorColor),
          ),
        );
      },
    );
  }
}
