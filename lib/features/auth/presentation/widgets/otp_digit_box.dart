import 'package:flutter/material.dart';

class OtpDigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;

  const OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isActive ? activeColor : inactiveColor,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: activeColor,
              width: 1.6,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}