import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/core/dependency_injection/injector.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_bloc/features/product/presentation/bloc/product_bloc.dart';
import 'package:shop_bloc/routes/auth_gate.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
        ),
        BlocProvider(
          create: (_) => sl<ProductBloc>()..add(const ProductsFetched()),
        ),
        BlocProvider(create: (_) => sl<CartBloc>()),
      ],
      child: MaterialApp(
        title: 'ShopBloc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const AuthGate(),
      ),
    );
  }
}