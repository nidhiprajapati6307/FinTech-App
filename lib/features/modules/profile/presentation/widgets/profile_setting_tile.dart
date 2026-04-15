import 'package:flutter/material.dart';

import '../../../../../core/utils/text_style.dart';

class ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconBgColor;
  final Color? iconColor;

  const ProfileSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: iconBgColor ?? const Color(0xffEEF2FF),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xff4F46E5),
          ),
        ),
        title: Text(
          title,
          style: TextStyleHelper.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle!,
          style: TextStyleHelper.bodySmall.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        )
            : null,
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
      ),
    );
  }
}