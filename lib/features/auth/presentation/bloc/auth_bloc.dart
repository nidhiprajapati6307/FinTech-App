import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_auth_state_stream_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetAuthStateStreamUseCase getAuthStateStreamUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  StreamSubscription<AppUser?>? _authSubscription;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.getAuthStateStreamUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(const AuthState()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<ClearAuthMessage>(_onClearAuthMessage);
  }

  Future<void> _onAuthStarted(
      AuthStarted event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    final currentUser = getCurrentUserUseCase();

    if (currentUser != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: currentUser,
        isBusy: false,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        isBusy: false,
        clearUser: true,
      ));
    }

    await _authSubscription?.cancel();
    _authSubscription = getAuthStateStreamUseCase().listen(
          (user) {
        add(AuthUserChanged(user));
      },
    );
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isBusy: false,
        message: 'Login successful',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      final user = await registerUseCase(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isBusy: false,
        message: 'Registration successful',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      await forgotPasswordUseCase(event.email);

      emit(state.copyWith(
        status: AuthStatus.passwordResetEmailSent,
        isBusy: false,
        message: 'Password reset email sent successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  Future<void> _onSendOtpRequested(
      SendOtpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      await sendOtpUseCase(
        phoneNumber: event.phoneNumber,
        codeSent: (verificationId) {
          add(
            AuthUserChanged({
              'type': 'otp_sent',
              'verificationId': verificationId,
            }),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  Future<void> _onVerifyOtpRequested(
      VerifyOtpRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (state.verificationId.isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: 'Verification ID is missing. Please send OTP again.',
      ));
      return;
    }

    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      final user = await verifyOtpUseCase(
        verificationId: state.verificationId,
        smsCode: event.smsCode,
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isBusy: false,
        message: 'OTP verified successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      isBusy: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      await logoutUseCase();

      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        isBusy: false,
        clearUser: true,
        message: 'Logged out successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        isBusy: false,
        error: _mapError(e),
      ));
    }
  }

  void _onAuthUserChanged(
      AuthUserChanged event,
      Emitter<AuthState> emit,
      ) {
    final payload = event.user;

    if (payload is Map<String, dynamic> && payload['type'] == 'otp_sent') {
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        isBusy: false,
        verificationId: payload['verificationId'] as String? ?? '',
        message: 'OTP sent successfully',
      ));
      return;
    }

    if (payload is AppUser) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: payload,
        isBusy: false,
      ));
      return;
    }

    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      isBusy: false,
      clearUser: true,
    ));
  }

  void _onClearAuthMessage(
      ClearAuthMessage event,
      Emitter<AuthState> emit,
      ) {
    emit(state.copyWith(
      clearError: true,
      clearMessage: true,
    ));
  }

  String _mapError(Object error) {
    final message = error.toString();
    return message
        .replaceFirst('Exception: ', '')
        .replaceFirst('ServerException: ', '');
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}