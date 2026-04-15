import 'package:flutter/material.dart';

class OtpResendRow extends StatelessWidget {
  final VoidCallback onResend;
  final Color primaryColor;
  final Color textDark;

  const OtpResendRow({
    super.key,
    required this.onResend,
    required this.primaryColor,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Didn't get the code? ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        GestureDetector(
          onTap: onResend,
          child: Text(
            'Resend it',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.access_time_filled,
          size: 16,
          color: Color(0xFFD1D5DB),
        ),
        const SizedBox(width: 4),
        Text(
          '45s',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ],
    );
  }
}