import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/onboarding_local_service.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_info_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/modules/dashboard/features/screens/dashboard.dart';
import '../../features/modules/main_navigation/presentation/pages/main_navigation.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter build(
      AuthBloc authBloc,
      OnboardingLocalService onboardingLocalService,
      ) {
    return GoRouter(
      initialLocation: RouteNames.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final onboardingCompleted =
        onboardingLocalService.isOnboardingCompleted();

        final currentPath = state.matchedLocation;

        final isSplash = currentPath == RouteNames.splash;
        final isOnboarding = currentPath == RouteNames.onboarding;
        final isLogin = currentPath == RouteNames.login;
        final isRegister = currentPath == RouteNames.register;
        final isForgotPassword = currentPath == RouteNames.forgotPassword;
        final isOtp = currentPath == RouteNames.otp;
        final isResetPasswordInfo =
            currentPath == RouteNames.resetPasswordInfo;
        final isResetPassword = currentPath == RouteNames.resetPassword;
        final isHome = currentPath == RouteNames.home;
        final isMainNavigation = currentPath == RouteNames.mainNavigation;

        final isAuthRoute = isLogin ||
            isRegister ||
            isForgotPassword ||
            isOtp ||
            isResetPasswordInfo ||
            isResetPassword;

        if (isSplash) return null;

        if (authState.status == AuthStatus.loading ||
            authState.status == AuthStatus.initial) {
          return null;
        }

        if (!onboardingCompleted) {
          return isOnboarding ? null : RouteNames.onboarding;
        }

        if (authState.status == AuthStatus.authenticated) {
          if (isAuthRoute || isOnboarding || isHome) {
            return RouteNames.mainNavigation;
          }
          return null;
        }

        final isUnauthenticated =
            authState.status == AuthStatus.unauthenticated ||
                authState.status == AuthStatus.error ||
                authState.status == AuthStatus.passwordResetEmailSent ||
                authState.status == AuthStatus.otpSent ||
                authState.status == AuthStatus.success;

        if (isUnauthenticated) {
          if (isMainNavigation || isHome || isOnboarding) {
            return RouteNames.login;
          }
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: RouteNames.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: RouteNames.otp,
          builder: (context, state) => OtpVerificationScreen(
            email: state.extra as String?,
          ),
        ),
        // GoRoute(
        //   path: RouteNames.resetPasswordInfo,
        //   builder: (context, state) => ResetPasswordInfoScreen(
        //     email: state.extra as String?,
        //   ),
        // ),
        GoRoute(
          path: RouteNames.resetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: RouteNames.mainNavigation,
          builder: (context, state) => const MainNavigationScreen(),
        ),
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}