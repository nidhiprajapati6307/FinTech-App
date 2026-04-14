class ProfileUser {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  const ProfileUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}