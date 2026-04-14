import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<AppUser> call({
    required String verificationId,
    required String smsCode,
  }) {
    return repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}