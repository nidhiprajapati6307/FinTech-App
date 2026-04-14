import '../../domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  passwordResetEmailSent,
  success,
  error,
}

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? message;
  final String? error;
  final String verificationId;
  final bool isBusy;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
    this.error,
    this.verificationId = '',
    this.isBusy = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? message,
    String? error,
    String? verificationId,
    bool? isBusy,
    bool clearMessage = false,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
      verificationId: verificationId ?? this.verificationId,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}