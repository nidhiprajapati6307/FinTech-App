import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      title: 'Manage all your cryptofolio\nin a single place',
      description:
      'With all your cryptocurrencies in one spot, managing them is made simple.',
      imagePath: 'assets/dashboard/img1.png',
    ),
    _OnboardingItem(
      title: 'Pay your various bills fast\nand without hassle',
      description:
      'Pay bills, manage transfers, and control your finances with ease.',
      imagePath: 'assets/dashboard/img2.png',
    ),
    _OnboardingItem(
      title: 'Track your finance and\nstay in full control',
      description:
      'Monitor activity, manage savings, and stay updated with your money flow.',
      imagePath: 'assets/dashboard/img3.png',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      context.go(RouteNames.login);
    }
  }

  void _handleNext() async {
    final isLastPage = _currentIndex == _pages.length - 1;

    if (isLastPage) {
      await _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 520 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 28 : 22,
                vertical: isTablet ? 20 : 16,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = _pages[index];
                        return _OnboardingPage(
                          item: item,
                          isTablet: isTablet,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBottomBar(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildBottomBar() {
    final isLastPage = _currentIndex == _pages.length - 1;

    return Row(
      children: [
        TextButton(
          onPressed: _completeOnboarding,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: List.generate(
            _pages.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 6),
              height: 7,
              width: _currentIndex == index ? 20 : 7,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primaryBlue
                    : AppColors.dotInactive,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        InkWell(
          onTap: _handleNext,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              isLastPage ? Icons.check_rounded : Icons.arrow_forward_ios_rounded,
              size: 20,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingItem item;
  final bool isTablet;

  const _OnboardingPage({
    required this.item,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: isTablet ? 30 : 20),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: isTablet ? 340 : 280,
              maxHeight: isTablet ? 420 : 330,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: isTablet ? 340 : 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 100,
                      color: AppColors.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 30 : 20,
                fontWeight: FontWeight.w800,
                height: 1.35,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 17 : 15,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}