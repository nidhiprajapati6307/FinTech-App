import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/responsive.dart';
import '../widgets/ad_banner_card.dart';
import '../widgets/balance_card.dart';
import '../widgets/blog_post_card.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/game_reward_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/referral_card.dart';
import '../widgets/youtube_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final screenPadding = Responsive.screenPadding(context);
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    final bool isSmallPhone = width < 380;
    final bool isLargeTablet = width >= 900;

    final int actionCrossAxisCount = isLargeTablet
        ? 4
        : isTablet
        ? 3
        : 3;

    final double quickActionAspectRatio = isLargeTablet
        ? 1.18
        : isTablet
        ? 1.05
        : isSmallPhone
        ? 0.82
        : 0.90;

    final double adHeight = isLargeTablet
        ? 200
        : isTablet
        ? 190
        : 180;

    final double gamesHeight = isLargeTablet
        ? 175
        : isTablet
        ? 168
        : 160;

    final double youtubeHeight = isLargeTablet
        ? 300
        : isTablet
        ? 290
        : isSmallPhone
        ? 280
        : 270;

    final bool useTwoColumnBlogs = width >= 900;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: screenPadding.copyWith(bottom: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width >= 1200
                    ? 920
                    : width >= 900
                    ? 820
                    : 700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: isTablet ? 30 : 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage your finances, rewards, and content in one place.',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      color: AppColors.textSecondary,
                      height: textScale > 1.15 ? 1.35 : 1.2,
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),

                  _buildBalanceSection(context),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'Quick Actions'),
                  const SizedBox(height: 14),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: actionCrossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: quickActionAspectRatio,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      QuickActionButton(
                        label: 'Deposit',
                        icon: Icons.account_balance_wallet_rounded,
                        onTap: () {},
                      ),
                      QuickActionButton(
                        label: 'Portfolio',
                        icon: Icons.pie_chart_rounded,
                        onTap: () {},
                      ),
                      QuickActionButton(
                        label: 'Token',
                        icon: Icons.token_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'Advertisements'),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: adHeight,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        AdBannerCard(
                          title: 'Earn More With Premium Savings',
                          subtitle: 'Unlock higher rewards and exclusive offers.',
                        ),
                        AdBannerCard(
                          title: 'Gold Investment Plan',
                          subtitle: 'Invest smartly and track your gold assets.',
                        ),
                        AdBannerCard(
                          title: 'Invite & Win Bonuses',
                          subtitle: 'Refer your friends and earn instantly.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'Games & Rewards'),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: gamesHeight,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        GameRewardCard(
                          title: 'Spin & Win',
                          reward: 'Earn up to ₹500',
                          icon: Icons.casino_rounded,
                        ),
                        GameRewardCard(
                          title: 'Scratch Card',
                          reward: 'Instant rewards',
                          icon: Icons.stars_rounded,
                        ),
                        GameRewardCard(
                          title: 'Quiz Challenge',
                          reward: 'Daily bonus points',
                          icon: Icons.quiz_rounded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'Referral Program'),
                  const SizedBox(height: 14),
                  ReferralCard(
                    referralCode: 'FINTECH2026',
                    referralLink: 'https://fintech.app/invite/FINTECH2026',
                    onInviteTap: () {},
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'YouTube Feed'),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: youtubeHeight,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        YoutubeCard(
                          title: 'How to grow your savings with smart strategies',
                          subtitle:
                          'Watch financial education and platform updates.',
                        ),
                        YoutubeCard(
                          title: 'Gold investment explained for beginners',
                          subtitle:
                          'Learn how digital gold can benefit you.',
                        ),
                        YoutubeCard(
                          title: 'Referral rewards and earning tips',
                          subtitle:
                          'Discover ways to maximize platform rewards.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  const DashboardSectionTitle(title: 'Latest Blogs'),
                  const SizedBox(height: 14),
                  if (useTwoColumnBlogs)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.15,
                      children: const [
                        BlogPostCard(
                          title: '5 easy ways to manage your personal finances',
                          description:
                          'Practical steps to improve savings, budgeting, and financial planning.',
                          date: '14 Apr 2026',
                        ),
                        BlogPostCard(
                          title: 'Why gold remains a strong long-term asset',
                          description:
                          'Understand why many investors still trust gold for stability.',
                          date: '11 Apr 2026',
                        ),
                        BlogPostCard(
                          title: 'How referrals can help you earn passive rewards',
                          description:
                          'A simple guide to sharing your code and growing your benefits.',
                          date: '08 Apr 2026',
                        ),
                      ],
                    )
                  else
                    const Column(
                      children: [
                        BlogPostCard(
                          title: '5 easy ways to manage your personal finances',
                          description:
                          'Practical steps to improve savings, budgeting, and financial planning.',
                          date: '14 Apr 2026',
                        ),
                        BlogPostCard(
                          title: 'Why gold remains a strong long-term asset',
                          description:
                          'Understand why many investors still trust gold for stability.',
                          date: '11 Apr 2026',
                        ),
                        BlogPostCard(
                          title: 'How referrals can help you earn passive rewards',
                          description:
                          'A simple guide to sharing your code and growing your benefits.',
                          date: '08 Apr 2026',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useColumn = width < 700;

    if (useColumn) {
      return Column(
        children: const [
          BalanceCard(
            title: 'Account Balance',
            amount: '₹ 1,24,500.00',
            subtitle: 'Available wallet balance',
            icon: Icons.account_balance_wallet_rounded,
            gradientColors: [
              AppColors.textPrimary,
              AppColors.primaryBlue,
            ],
          ),
          SizedBox(height: 14),
          BalanceCard(
            title: 'Gold Balance',
            amount: '12.75 gm',
            subtitle: 'Current gold holdings',
            icon: Icons.workspace_premium_rounded,
            gradientColors: [
              Color(0xffB7791F),
              Color(0xffD69E2E),
            ],
          ),
        ],
      );
    }

    return const Row(
      children: [
        Expanded(
          child: BalanceCard(
            title: 'Account Balance',
            amount: '₹ 1,24,500.00',
            subtitle: 'Available wallet balance',
            icon: Icons.account_balance_wallet_rounded,
            gradientColors: [
              AppColors.textPrimary,
              AppColors.primaryBlue,
            ],
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: BalanceCard(
            title: 'Gold Balance',
            amount: '12.75 gm',
            subtitle: 'Current gold holdings',
            icon: Icons.workspace_premium_rounded,
            gradientColors: [
              Color(0xffB7791F),
              Color(0xffD69E2E),
            ],
          ),
        ),
      ],
    );
  }
}