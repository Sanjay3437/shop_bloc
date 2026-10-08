import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_bloc/core/utils/validators.dart';
import '../../../../core/constants/routes.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
      current.errorMessage != null &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Log in to continue shopping',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              enabled: !state.isSubmitting,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              enabled: !state.isSubmitting,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              validator: Validators.password,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: state.isSubmitting ? null : _submit,
                              child: state.isSubmitting
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text('Login'),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () => context.push(AppRoutes.signup),
                              child: const Text(
                                "Don't have an account? Sign up",
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}