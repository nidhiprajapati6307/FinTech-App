import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_shell.dart';
import '../../../../core/widgets/outline_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.maxFormWidth(context);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: AuthShell(
        title: 'Forgot Password',
        subtitle: 'Enter your email and we will send an OTP to your email.',
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.passwordResetEmailSent) {
              context.go(
                RouteNames.otp,
                extra: _emailController.text.trim(),
              );
            }

            if (state.status == AuthStatus.error && state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryBlue,
                  content: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
              context.read<AuthBloc>().add(ClearAuthMessage());
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
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
                          children: [
                            Container(
                              height: 68,
                              width: 68,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.lock_reset_rounded,
                                color: AppColors.primaryBlue,
                                size: 34,
                              ),
                            ),
                            const SizedBox(height: 22),
                            AppTextField(
                              controller: _emailController,
                              hint: 'Email address',
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 22),
                            if (state.isBusy)
                              Container(
                                width: double.infinity,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              CommonPrimaryButton(
                                text: 'Send OTP',
                                icon: Icons.mail_outline_rounded,
                                onPressed: _submitForgotPassword,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      CommonOutlineButton(
                        onPressed: () => context.go(RouteNames.login),
                        text: 'Back to Login',
                        icon: Icons.arrow_back_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}