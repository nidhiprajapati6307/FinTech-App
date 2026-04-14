import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalService {
  static const String _onboardingKey = 'onboarding_completed';

  final SharedPreferences sharedPreferences;

  OnboardingLocalService(this.sharedPreferences);

  bool isOnboardingCompleted() {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }
}