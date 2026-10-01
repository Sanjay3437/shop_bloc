part of 'auth_bloc.dart';

enum AuthStatus {
  /// Still checking for a saved session (app just started).
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;

  /// True while a login or signup request is running.
  final bool isSubmitting;

  /// Set when the last action failed; shown by the login/signup screens.
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, user, isSubmitting, errorMessage];
}