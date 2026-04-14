import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetAuthStateStreamUseCase {
  final AuthRepository repository;
  GetAuthStateStreamUseCase(this.repository);

  Stream<AppUser?> call() {
    return repository.authStateChanges();
  }
}