class AppUser {
  final String uid;
  final String? email;
  final String? fullName;

  const AppUser({
    required this.uid,
    this.email,
    this.fullName,
  });
}