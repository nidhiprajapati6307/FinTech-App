import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<AppUser?> authStateChanges() => remoteDataSource.authStateChanges();

  @override
  Future<void> forgotPassword(String email) {
    return remoteDataSource.forgotPassword(email);
  }

  @override
  AppUser? getCurrentUser() => remoteDataSource.getCurrentUser();

  @override
  Future<bool> getOnboardingCompleted() {
    return localDataSource.getOnboardingCompleted();
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
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
  Future<void> setOnboardingCompleted() {
    return localDataSource.setOnboardingCompleted();
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
}