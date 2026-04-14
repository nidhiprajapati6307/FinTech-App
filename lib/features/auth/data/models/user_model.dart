import '../../domain/entities/user_entity.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    super.email,
    super.fullName,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return UserModel(
      uid: json['uid']?.toString() ?? docId,
      email: json['email']?.toString(),
      fullName: json['fullName']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}