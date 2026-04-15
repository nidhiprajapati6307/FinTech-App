import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/back_circle_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/otp_digit_box.dart';
import '../widgets/otp_resend_row.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;

  const OtpVerificationScreen({
    super.key,
    this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  static const Color kPrimaryGreen = Color(0xFF0B8A68);
  static const Color kLightBorder = Color(0xFFE5E7EB);
  static const Color kTextDark = Color(0xFF2F2F2F);
  static const Color kTextLight = Color(0xFF6B7280);

  String get _otp => _controllers.map((e) => e.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _verifyOtp() {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6 digit OTP')),
      );
      return;
    }

    context.go(RouteNames.resetPassword);
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailText = widget.email ?? '*******@gmail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthBackCircleButton(
                onTap: () => context.pop(),
                backgroundColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 34),
              const Text(
                'We just sent an OTP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: kTextLight,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Enter the security code we sent to\n',
                    ),
                    TextSpan(
                      text: emailText,
                      style: const TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '  '),
                    // WidgetSpan(
                    //   alignment: PlaceholderAlignment.middle,
                    //   child: GestureDetector(
                    //     onTap: () => context.pop(),
                    //     child: const Text(
                    //       'Edit',
                    //       style: TextStyle(
                    //         color: AppColors.textPrimary,
                    //         fontWeight: FontWeight.w700,
                    //         fontSize: 13,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => OtpDigitBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) => _onChanged(value, index),
                    isActive: index == 0,
                    activeColor: kPrimaryGreen,
                    inactiveColor: kLightBorder,
                    textColor: kTextDark,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              OtpResendRow(
                onResend: _resendOtp,
                primaryColor: AppColors.textPrimary,
                textDark: kTextDark,
              ),
              const Spacer(),
              CommonPrimaryButton(
                text: 'Verify OTP',
                onPressed: _otp.length == 6 ? _verifyOtp : null, icon: null,

              ),
            ],
          ),
        ),
      ),
    );
  }
}