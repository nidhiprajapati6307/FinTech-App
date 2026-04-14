import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth firebaseAuth;

  ProfileRepositoryImpl({required this.firebaseAuth});

  @override
  Future<ProfileUser> getCurrentUserProfile() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No logged in user found');
    }

    return ProfileUser(
      uid: user.uid,
      name: (user.displayName != null && user.displayName!.trim().isNotEmpty)
          ? user.displayName!.trim()
          : 'Guest User',
      email: user.email ?? 'No email found',
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}