import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/outline_button.dart';
import '../../../../core/widgets/primary_button.dart';

class ResetPasswordInfoScreen extends StatelessWidget {
  final String? email;

  const ResetPasswordInfoScreen({
    super.key,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.maxFormWidth(context);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: Responsive.screenPadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.06),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_rounded,
                        color: AppColors.primaryBlue,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Check Your Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email == null || email!.isEmpty
                          ? 'We have sent a password reset link to your email address. Open the email, reset your password, then come back and login again.'
                          : 'We have sent a password reset link to $email. Open the email, reset your password, then come back and login again.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CommonPrimaryButton(
                      text: 'Back to Login',
                      icon: Icons.login_rounded,
                      onPressed: () => context.go(RouteNames.login),
                    ),
                    const SizedBox(height: 14),
                    CommonOutlineButton(
                      onPressed: () => context.go(RouteNames.forgotPassword),
                      text: 'Send Again',
                      icon: Icons.refresh_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}