abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });
}

class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  RegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});
}

class SendOtpRequested extends AuthEvent {
  final String phoneNumber;

  SendOtpRequested({required this.phoneNumber});
}

class VerifyOtpRequested extends AuthEvent {
  final String smsCode;

  VerifyOtpRequested({required this.smsCode});
}

class LogoutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final dynamic user;

  AuthUserChanged(this.user);
}

class ClearAuthMessage extends AuthEvent {}