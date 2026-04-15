import 'package:flutter/material.dart';

class AuthBackCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const AuthBackCircleButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: iconColor,
        ),
      ),
    );
  }
}