import '../../domain/entities/profile_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileUser user;

  const ProfileLoaded(this.user);
}

class ProfileLogoutLoading extends ProfileState {
  const ProfileLogoutLoading();
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}