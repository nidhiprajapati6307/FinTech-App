import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/get_auth_state_stream_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../services/onboarding_local_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }

  if (!getIt.isRegistered<FirebaseAuth>()) {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  if (!getIt.isRegistered<FirebaseFirestore>()) {
    getIt.registerLazySingleton<FirebaseFirestore>(
          () => FirebaseFirestore.instance,
    );
  }

  if (!getIt.isRegistered<OnboardingLocalService>()) {
    getIt.registerLazySingleton<OnboardingLocalService>(
          () => OnboardingLocalService(getIt<SharedPreferences>()),
    );
  }

  if (!getIt.isRegistered<AuthLocalDataSource>()) {
    getIt.registerLazySingleton<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );
  }

  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(
        firebaseAuth: getIt<FirebaseAuth>(),
      ),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
          () => LoginUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(
          () => RegisterUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<ForgotPasswordUseCase>()) {
    getIt.registerLazySingleton<ForgotPasswordUseCase>(
          () => ForgotPasswordUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton<LogoutUseCase>(
          () => LogoutUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
          () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAuthStateStreamUseCase>()) {
    getIt.registerLazySingleton<GetAuthStateStreamUseCase>(
          () => GetAuthStateStreamUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<SendOtpUseCase>()) {
    getIt.registerLazySingleton<SendOtpUseCase>(
          () => SendOtpUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<VerifyOtpUseCase>()) {
    getIt.registerLazySingleton<VerifyOtpUseCase>(
          () => VerifyOtpUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerFactory<AuthBloc>(
          () => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
        getAuthStateStreamUseCase: getIt<GetAuthStateStreamUseCase>(),
        sendOtpUseCase: getIt<SendOtpUseCase>(),
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      ),
    );
  }
}