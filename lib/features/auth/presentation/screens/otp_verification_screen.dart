import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_shell.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _showOtpField = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SendOtpRequested(
          phoneNumber: _phoneController.text.trim(),
        ),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    context.read<AuthBloc>().add(
      VerifyOtpRequested(
        smsCode: _otpController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: AuthShell(
        title: 'OTP Verification',
        subtitle: 'Enter your phone number and verify with OTP.',
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.otpSent) {
              setState(() {
                _showOtpField = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryBlue,
                  content: Text(
                    state.message ?? 'OTP sent successfully',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
              context.read<AuthBloc>().add(ClearAuthMessage());
            }

            if (state.status == AuthStatus.authenticated) {
              context.go(RouteNames.home);
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
            final isSendingOtp =
                state.isBusy && state.status == AuthStatus.loading && !_showOtpField;
            final isVerifyingOtp =
                state.isBusy && state.status == AuthStatus.loading && _showOtpField;

            return Form(
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
                          child: Icon(
                            _showOtpField
                                ? Icons.password_rounded
                                : Icons.sms_outlined,
                            color: AppColors.primaryBlue,
                            size: 34,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AppTextField(
                          controller: _phoneController,
                          hint: 'Phone number with country code',
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                        ),
                        const SizedBox(height: 18),
                        if (isSendingOtp)
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
                            text: 'Send OTP',
                            icon: Icons.send_to_mobile_rounded,
                            onPressed: _sendOtp,
                          ),
                        if (_showOtpField) ...[
                          const SizedBox(height: 22),
                          AppTextField(
                            controller: _otpController,
                            hint: 'Enter OTP',
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                Validators.validateRequired(value, 'OTP'),
                          ),
                          const SizedBox(height: 18),
                          if (isVerifyingOtp)
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
                              text: 'Verify OTP',
                              icon: Icons.verified_user_rounded,
                              onPressed: _verifyOtp,
                            ),
                        ],
                      ],
                    ),
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