import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Login failed. User not found.');
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Registration failed. User not created.');
      }

      await user.updateDisplayName(fullName);

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        fullName: fullName,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  AppUser? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
    );
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? '',
      );
    });
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(_mapFirebaseError(e));
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<AppUser> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await firebaseAuth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        throw Exception('OTP verification failed.');
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        fullName: user.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Something went wrong.';
    }
  }
}