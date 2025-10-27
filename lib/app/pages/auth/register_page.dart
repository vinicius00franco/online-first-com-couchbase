import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/theme/app_colors.dart';
import 'package:checklist/app/theme/app_spacing.dart';
import 'package:checklist/app/theme/app_text_styles.dart';
import 'package:checklist/app/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onNavigateToLogin});

  final VoidCallback onNavigateToLogin;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    context.read<AuthCubit>().register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthError || current is AuthAuthenticated,
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }

        if (state is AuthAuthenticated) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onNavigateToLogin,
          ),
          title: const Text('Criar conta'),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          padding: AppSpacing.screenPadding
              .copyWith(top: AppSpacing.xl + kToolbarHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.cardBorderRadius,
                ),
                child: SingleChildScrollView(
                  padding: AppSpacing.cardPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Cadastre-se',
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: const Key('register_name_field'),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'Informe o nome';
                            }
                            if (text.length < 3) {
                              return 'O nome deve ter pelo menos 3 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: const Key('register_email_field'),
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'Informe o e-mail';
                            }
                            if (!text.contains('@')) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: const Key('register_password_field'),
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (value) {
                            final text = value ?? '';
                            if (text.isEmpty) {
                              return 'Informe a senha';
                            }
                            if (text.length < 6) {
                              return 'A senha deve ter ao menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: const Key('register_confirm_field'),
                          controller: _confirmController,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar senha',
                            prefixIcon: Icon(Icons.lock_reset),
                          ),
                          obscureText: true,
                          validator: (value) {
                            final confirmation = value ?? '';
                            if (confirmation.isEmpty) {
                              return 'Confirme a senha';
                            }
                            if (confirmation != _passwordController.text) {
                              return 'As senhas não conferem';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          height: AppTheme.buttonHeight,
                          child: ElevatedButton(
                            key: const Key('register_submit_button'),
                            onPressed: _submit,
                            child: const Text('Cadastrar'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextButton.icon(
                          key: const Key('register_login_button'),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: widget.onNavigateToLogin,
                          label: const Text('Já tenho conta'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
