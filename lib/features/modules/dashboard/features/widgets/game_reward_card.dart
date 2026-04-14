import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class GameRewardCard extends StatelessWidget {
  final String title;
  final String reward;
  final IconData icon;

  const GameRewardCard({
    super.key,
    required this.title,
    required this.reward,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
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
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue.withOpacity(0.10),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reward,
            style: const TextStyle(
              color: Color(0xff12A36D),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}