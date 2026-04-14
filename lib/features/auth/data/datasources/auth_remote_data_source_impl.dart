import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      firestore.collection('users');

  Future<UserModel> _getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw ServerException('User profile not found in Firestore');
    }

    return UserModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw ServerException('Registration failed');
      }

      await firebaseUser.updateDisplayName(fullName);

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email,
        fullName: fullName,
      );

      await _usersCollection.doc(firebaseUser.uid).set(userModel.toFirestore());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw ServerException('Login failed');
      }

      return await _getUserProfile(firebaseUser.uid);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Login failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to send reset email');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Logout failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  AppUser? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      email: user.email,
      fullName: user.displayName,
    );
  }

  @override
  Stream<AppUser?> authStateChanges() {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        return await _getUserProfile(firebaseUser.uid);
      } catch (_) {
        return UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email,
          fullName: firebaseUser.displayName,
        );
      }
    });
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw ServerException(e.message ?? 'OTP verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Failed to send OTP');
    } catch (e) {
      throw ServerException(e.toString());
    }
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
      final firebaseUser = result.user;

      if (firebaseUser == null) {
        throw ServerException('OTP verification failed');
      }

      final doc = await _usersCollection.doc(firebaseUser.uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, doc.id);
      }

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        fullName: firebaseUser.displayName,
      );

      await _usersCollection.doc(firebaseUser.uid).set(userModel.toFirestore());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Invalid OTP');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}