import '../entities/profile_user.dart';

abstract class ProfileRepository {
  Future<ProfileUser> getCurrentUserProfile();
  Future<void> logout();
}