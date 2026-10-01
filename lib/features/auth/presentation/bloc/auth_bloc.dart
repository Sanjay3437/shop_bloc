import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/use_case/get_current_user.dart';
import '../../domain/use_case/sign_in.dart';
import '../../domain/use_case/sign_out.dart';
import '../../domain/use_case/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;

  AuthBloc({
    required this.getCurrentUser,
    required this.signIn,
    required this.signUp,
    required this.signOut,
  }) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await getCurrentUser(const NoParams());

    result.fold(
      // Couldn't read the session: treat as logged out.
          (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
          (user) => emit(
        user == null
            ? const AuthState(status: AuthStatus.unauthenticated)
            : AuthState(status: AuthStatus.authenticated, user: user),
      ),
    );
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthState(
      status: AuthStatus.unauthenticated,
      isSubmitting: true,
    ));

    final result = await signIn(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) => emit(AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: failure.message,
      )),
          (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthState(
      status: AuthStatus.unauthenticated,
      isSubmitting: true,
    ));

    final result = await signUp(
      SignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: failure.message,
      )),
          (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    final result = await signOut(const NoParams());

    result.fold(
      // Logout failed: stay logged in and report why.
          (failure) => emit(AuthState(
        status: AuthStatus.authenticated,
        user: state.user,
        errorMessage: failure.message,
      )),
          (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }
}