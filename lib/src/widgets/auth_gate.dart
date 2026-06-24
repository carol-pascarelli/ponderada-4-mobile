import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ponderada_4_mobile/src/providers/auth_provider.dart';
import 'package:ponderada_4_mobile/src/screens/auth/login_screen.dart';
import 'package:ponderada_4_mobile/src/screens/dashboard/dashboard_screen.dart';
import 'package:ponderada_4_mobile/src/widgets/loading_widget.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading && auth.user == null && auth.isAuthenticated) {
          return const Scaffold(
            body: LoadingWidget(message: 'Carregando...'),
          );
        }

        if (!auth.isAuthenticated) {
          return const LoginScreen();
        }

        return const DashboardScreen();
      },
    );
  }
}
