import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_shell.dart';
import '../../../../core/widgets/outline_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: AuthShell(
        title: 'Welcome Back',
        subtitle: 'Login to continue to your account.',
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              context.go(RouteNames.mainNavigation);
            }

            if (state.status == AuthStatus.error && state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryBlue,
                  content: Text(
                    state.error!,
                    style: TextStyleHelper.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
              context.read<AuthBloc>().add(ClearAuthMessage());
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
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
                            Icons.account_balance_wallet_rounded,
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
                        const SizedBox(height: AppConstants.paddingMedium),
                        AppTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          label: 'Password',
                          obscureText: _obscurePassword,
                          validator: Validators.validatePassword,
                          onChanged: (_) => setState(() {}),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primaryBlue,
                          ),
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
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(RouteNames.forgotPassword),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyleHelper.labelMedium.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          CommonPrimaryButton(
                            text: 'Login',
                            icon: Icons.login_rounded,
                            onPressed: _submitLogin,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  CommonOutlineButton(
                    onPressed: () => context.push(RouteNames.register),
                    text: 'Create Account',
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}