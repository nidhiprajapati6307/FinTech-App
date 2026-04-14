import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> forgotPassword(String email);

  Future<void> logout();

  AppUser? getCurrentUser();

  Stream<AppUser?> authStateChanges();

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
  });

  Future<AppUser> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}