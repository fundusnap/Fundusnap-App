import 'package:sugeye/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
  Stream<AppUser?> get authStateChanges;
}
