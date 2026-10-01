import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_bloc/features/product/presentation/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Fires only on the authenticated -> unauthenticated transition.
      listenWhen: (previous, current) =>
      previous.status == AuthStatus.authenticated &&
          current.status == AuthStatus.unauthenticated,
      listener: (context, _) =>
          context.read<CartBloc>().add(const CartCleared()),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return switch (state.status) {
            AuthStatus.unknown => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            AuthStatus.authenticated => const HomePage(),
            AuthStatus.unauthenticated => const LoginPage(),
          };
        },
      ),
    );
  }
}