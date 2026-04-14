import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;
  SendOtpUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
  }) {
    return repository.sendOtp(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
    );
  }
}