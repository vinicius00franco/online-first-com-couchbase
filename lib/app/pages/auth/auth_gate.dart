import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/pages/auth/login_page.dart';
import 'package:checklist/app/pages/auth/register_page.dart';
import 'package:checklist/app/pages/checklist_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return const ChecklistPage();
        }

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
      },
    );
  }
}
