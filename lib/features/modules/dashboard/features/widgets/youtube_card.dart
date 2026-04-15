import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/text_style.dart';

class YoutubeCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const YoutubeCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallPhone = width < 380;

    return Container(
      width: isSmallPhone ? 240 : 260,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.dotInactive),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: isSmallPhone ? 120 : 130,
            decoration: BoxDecoration(
              color: const Color(0xff111827),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                size: 54,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyleHelper.labelMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: isSmallPhone ? 14 : 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyleHelper.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: isSmallPhone ? 12 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}