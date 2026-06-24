import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/core/routes/app_routes.dart';
import 'package:ponderada_4_mobile/src/providers/auth_provider.dart';
import 'package:ponderada_4_mobile/src/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    auth.clearError();

    final success = await auth.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reminders',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organize seus estudos',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe seu e-mail';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Entrar',
                    isLoading: auth.isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    label: 'Cadastrar',
                    outlined: true,
                    onPressed: auth.isLoading
                        ? null
                        : () => Navigator.pushNamed(context, AppRoutes.register),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
