import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/text_style.dart';

class AdBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdBannerCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(AppConstants.paddingLarge - 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.textPrimary,
            AppColors.primaryBlue,
            AppColors.primaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.campaign_rounded,
            color: Colors.white,
            size: 28,
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyleHelper.labelLarge.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyleHelper.bodySmall.copyWith(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}