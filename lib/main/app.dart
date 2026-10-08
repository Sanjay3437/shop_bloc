import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/core/dependency_injection/injector.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_bloc/features/product/presentation/bloc/product_bloc.dart';
import 'package:shop_bloc/routes/app_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthStarted());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(
          create: (_) => sl<ProductBloc>()..add(const ProductsFetched()),
        ),
        BlocProvider(create: (_) => sl<CartBloc>()),
      ],
      child: MaterialApp.router(
        title: 'ShopBloc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        routerConfig: _appRouter.router,
      ),
    );
  }
}