import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
      previous.status != current.status ||
          (current.errorMessage != null &&
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Signed up and logged in: drop back to the root, where the
          // route guard now shows the app.
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create account')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthTextField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person_outline,
                        enabled: !state.isSubmitting,
                        textInputAction: TextInputAction.next,
                        validator: Validators.name,
                      ),
                      const SizedBox(height: 16),
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
                        textInputAction: TextInputAction.next,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmController,
                        label: 'Confirm password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        enabled: !state.isSubmitting,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (v) => Validators.confirmPassword(
                          v,
                          _passwordController.text,
                        ),
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
                            : const Text('Sign up'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}