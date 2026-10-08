import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_bloc/core/constants/routes.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:shop_bloc/features/auth/presentation/pages/signup_page.dart';
import 'package:shop_bloc/features/cart/presentation/pages/cart_page.dart';
import 'package:shop_bloc/features/product/domain/entities/product.dart';
import 'package:shop_bloc/features/product/presentation/pages/home_page.dart';
import 'package:shop_bloc/features/product/presentation/pages/product_detail_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterAuthNotifier(authBloc),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isUnknown = authState.status == AuthStatus.unknown;

      final onAuthPage = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      // Still checking session — don't redirect yet
      if (isUnknown) return null;

      // Not logged in and not on an auth page → go to login
      if (!isLoggedIn && !onAuthPage) return AppRoutes.login;

      // Logged in but on an auth page → go to home
      if (isLoggedIn && onAuthPage) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
    ],
  );
}

/// Bridges AuthBloc state changes into GoRouter's refresh mechanism.
class GoRouterAuthNotifier extends ChangeNotifier {
  GoRouterAuthNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}