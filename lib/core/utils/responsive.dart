import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static double maxFormWidth(BuildContext context) =>
      isTablet(context) ? 480 : 420;

  static EdgeInsets screenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    if (width >= 600) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }
}