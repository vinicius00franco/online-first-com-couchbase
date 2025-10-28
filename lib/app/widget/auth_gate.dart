import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/pages/auth/login_page.dart';
import 'package:checklist/app/pages/auth/register_page.dart';

/// Widget that guards authenticated routes.
/// Redirects to LoginPage if user is not authenticated.
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return child;
        } else {
          // Not authenticated, show login page with navigation to register
          return LoginPage(
            onNavigateToRegister: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthCubit>(),
                    child: RegisterPage(
                      onNavigateToLogin: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
