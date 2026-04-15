import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    return remoteDataSource.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> forgotPassword(String email) {
    return remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  AppUser? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
  }) {
    return remoteDataSource.sendOtp(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
    );
  }

  @override
  Future<AppUser> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    return remoteDataSource.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<void> setOnboardingCompleted() {
    throw UnimplementedError();
  }

  @override
  Future<bool> getOnboardingCompleted() {
    throw UnimplementedError();
  }
}