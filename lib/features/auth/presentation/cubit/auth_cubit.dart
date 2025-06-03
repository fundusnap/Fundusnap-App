import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sugeye/features/auth/data/repositories/custom_auth_repository.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';
import 'package:sugeye/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AppUser?>? _authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    // ? listen to authentication state changes from the repository
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (appUser) {
        if (appUser != null) {
          emit(AuthAuthenticated(user: appUser));
        } else {
          emit(AuthUnauthenticated());
        }
      },
      onError: (error) {
        print("AuthCubit: Error from authStateChanges stream: $error");
        emit(
          AuthError(
            message:
                "An error occurred in the authentication stream: ${error.toString()}",
          ),
        );
      },
    );
    // ? Trigger an initial check of the current user status.
    // ? sThe repository's getCurrentUser() method should emit to its authStateChanges stream.
    _authRepository.getCurrentUser();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      // The repository's signInWithEmail method should either return AppUser
      // and internally update the authStateChanges stream, or return null on failure
      // and also update the stream to null.
      final appUser = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      // If signInWithEmail returns null (indicating failure) and the stream
      // hasn't already pushed an AuthUnauthenticated state, we ensure it.
      // However, CustomAuthRepositoryImpl is designed to update the stream on failure.
      if (appUser == null &&
          state is! AuthUnauthenticated &&
          state is! AuthError) {
        // This case might be redundant if repository handles stream updates on failure correctly
        print(
          "AuthCubit: signInWithEmail returned null, ensuring Unauthenticated state if not already set by stream.",
        );
        if (state is! AuthAuthenticated) {
          // Avoid emitting unauthenticated if somehow stream emitted authenticated first
          emit(AuthUnauthenticated());
        }
      }
      // Successful authentication will be handled by the _authStateSubscription.
    } catch (e) {
      // Catch errors thrown directly by the repository method if it doesn't
      // handle all errors by returning null or updating the stream.
      print("AuthCubit: Error during signIn: $e");
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      // Similar to signIn, repository method should handle stream updates.
      final appUser = await _authRepository.signUpWithEmail(
        email: email,
        password:
            password, // Ensure your repository interface has this corrected
      );

      if (appUser == null &&
          state is! AuthUnauthenticated &&
          state is! AuthError) {
        // Similar redundancy check as in signIn
        print(
          "AuthCubit: signUpWithEmail returned null, ensuring Unauthenticated state if not already set by stream.",
        );
        if (state is! AuthAuthenticated) {
          emit(AuthUnauthenticated());
        }
      }
      // Successful authentication will be handled by the _authStateSubscription.
    } catch (e) {
      print("AuthCubit: Error during signUp: $e");
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    // Emitting AuthLoading is optional here as signOut is usually quick
    // emit(AuthLoading());
    try {
      await _authRepository.signOut();
      // The _authStateSubscription will automatically receive the null user
      // from authStateChanges and emit AuthUnauthenticated.
    } catch (e) {
      print("AuthCubit: Error during signOut: $e");
      emit(AuthError(message: e.toString()));
    }
  }

  // ? when the Cubit is no longer needed, typically by BLoC provider.
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    // If your AuthRepository implementation (CustomAuthRepositoryImpl) has a dispose method
    // for its StreamController, you should call it here.
    // This requires AuthRepository to define a dispose method or casting.
    // Example: (_authRepository as CustomAuthRepositoryImpl).dispose();
    // A cleaner way is to add `void dispose();` to the AuthRepository interface.
    if (_authRepository is CustomAuthRepositoryImpl) {
      (_authRepository).dispose();
    }
    return super.close();
  }
}
