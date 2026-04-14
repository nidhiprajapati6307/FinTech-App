import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> setOnboardingCompleted();
  Future<bool> getOnboardingCompleted();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  static const String _onboardingKey = 'onboarding_completed';

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }

  @override
  Future<bool> getOnboardingCompleted() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }
}