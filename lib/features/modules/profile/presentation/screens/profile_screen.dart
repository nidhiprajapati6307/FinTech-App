import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_setting_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isTablet = Responsive.isTablet(context);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Logout',
            style: TextStyleHelper.titleSmall.copyWith(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyleHelper.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: isTablet ? 15 : 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyleHelper.labelMedium.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ProfileBloc>().add(const LogoutProfileEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyleHelper.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double _maxProfileWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) return 560;
    if (width >= 600) return 500;
    return 420;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final maxWidth = _maxProfileWidth(context);
    final screenPadding = Responsive.screenPadding(context);
    final width = MediaQuery.of(context).size.width;
    final isSmallPhone = width < 380;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBg,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoggedOut) {
              context.go(RouteNames.login);
            }

            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryBlue,
                  content: Text(
                    state.message,
                    style: TextStyleHelper.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                ),
              );
            }

            if (state is ProfileLogoutLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                ),
              );
            }

            if (state is ProfileLoaded) {
              final user = state.user;

              return SingleChildScrollView(
                padding: screenPadding.copyWith(bottom: AppConstants.paddingLarge),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isTablet ? 12 : 8),

                        Center(
                          child: Text(
                            'My Profile',
                            style: TextStyleHelper.headlineSmall.copyWith(
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 24 : 20),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(
                            isTablet ? 24 : (isSmallPhone ? 18 : 20),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBlue,
                                AppColors.primaryBlue.withOpacity(0.90),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.08),
                            ),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: isTablet ? 54 : (isSmallPhone ? 42 : 46),
                                backgroundColor: Colors.white,
                                backgroundImage:
                                user.photoUrl != null && user.photoUrl!.isNotEmpty
                                    ? NetworkImage(user.photoUrl!)
                                    : null,
                                child: user.photoUrl == null || user.photoUrl!.isEmpty
                                    ? Icon(
                                  Icons.person,
                                  size: isTablet ? 54 : (isSmallPhone ? 42 : 46),
                                  color: AppColors.primaryBlue,
                                )
                                    : null,
                              ),
                              SizedBox(height: isTablet ? 18 : 14),
                              Text(
                                user.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.titleSmall.copyWith(
                                  color: Colors.white,
                                  fontSize: isTablet ? 24 : 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user.email,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyleHelper.bodySmall.copyWith(
                                  color: Colors.white70,
                                  fontSize: isTablet ? 15 : 14,
                                  height: textScale > 1.15 ? 1.35 : 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isTablet ? 28 : 24),

                        _buildSectionTitle('Account', isTablet),
                        ProfileSettingTile(
                          icon: Icons.person_outline,
                          title: 'Personal Information',
                          subtitle: 'View and manage your profile details',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          onTap: () {},
                        ),
                        ProfileSettingTile(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          onTap: () {},
                        ),

                        SizedBox(height: isTablet ? 18 : 14),

                        _buildSectionTitle('Preferences', isTablet),
                        ProfileSettingTile(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          subtitle: 'Enable or disable app notifications',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          trailing: Switch(
                            activeColor: AppColors.primaryBlue,
                            value: notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                        ProfileSettingTile(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          subtitle: 'Switch app appearance',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          trailing: Switch(
                            activeColor: AppColors.primaryBlue,
                            value: darkModeEnabled,
                            onChanged: (value) {
                              setState(() {
                                darkModeEnabled = value;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: isTablet ? 18 : 14),

                        _buildSectionTitle('Support', isTablet),
                        ProfileSettingTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help about app usage',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          onTap: () {},
                        ),
                        ProfileSettingTile(
                          icon: Icons.info_outline,
                          title: 'About App',
                          subtitle: 'App version and information',
                          iconBgColor: AppColors.primaryBlue.withOpacity(0.08),
                          iconColor: AppColors.primaryBlue,
                          onTap: () {},
                        ),

                        SizedBox(height: isTablet ? 28 : 24),

                        CommonPrimaryButton(
                          text: 'Logout',
                          icon: Icons.logout_rounded,
                          onPressed: _showLogoutDialog,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: screenPadding,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyleHelper.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: isTablet ? 16 : 15,
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyleHelper.labelLarge.copyWith(
          fontSize: isTablet ? 19 : 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}