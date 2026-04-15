import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/back_circle_button.dart';
import '../../../../core/widgets/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const Color kTextLight = Color(0xFF6B7280);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset successful')),
    );

    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _passwordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            18,
            22,
            AppConstants.paddingLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthBackCircleButton(
                onTap: () => context.pop(),
                backgroundColor: AppColors.textPrimary,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Text(
                'Reset Password',
                style: TextStyleHelper.headlineSmall.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'Create your new password to continue.',
                style: TextStyleHelper.bodySmall.copyWith(
                  color: kTextLight,
                ),
              ),
              const SizedBox(height: 28),
              AppTextField(
                controller: _passwordController,
                hint: 'New Password',
                obscureText: _obscurePassword,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              AppTextField(
                controller: _confirmPasswordController,
                hint: 'Confirm Password',
                obscureText: _obscureConfirmPassword,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              CommonPrimaryButton(
                text: 'Reset Password',
                icon: Icons.lock_reset_rounded,
                onPressed: isButtonEnabled ? _resetPassword : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}