import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/theme/app_colors.dart';
import 'package:checklist/app/theme/app_spacing.dart';
import 'package:checklist/app/theme/app_text_styles.dart';
import 'package:checklist/app/theme/app_theme.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _populate(UserEntity user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _passwordController.clear();
    _confirmController.clear();
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<AuthCubit>().updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.isEmpty
              ? null
              : _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthError ||
          current is AuthAuthenticated ||
          current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }

        if (state is AuthAuthenticated) {
          _populate(state.user);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Dados atualizados com sucesso.')),
            );
        }
        if (state is AuthUnauthenticated && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          padding: AppSpacing.screenPadding,
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
                          'Suas informações',
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: const Key('profile_name_field'),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: const Key('profile_email_field'),
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
                          key: const Key('profile_password_field'),
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Nova senha',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (value) {
                            final text = value ?? '';
                            if (text.isEmpty) {
                              return null;
                            }
                            if (text.length < 6) {
                              return 'A senha deve ter ao menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextFormField(
                          key: const Key('profile_confirm_field'),
                          controller: _confirmController,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar nova senha',
                            prefixIcon: Icon(Icons.lock_reset),
                          ),
                          obscureText: true,
                          validator: (value) {
                            final confirmation = value ?? '';
                            if (_passwordController.text.isEmpty) {
                              return null;
                            }
                            if (confirmation.isEmpty) {
                              return 'Confirme a nova senha';
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
                          child: ElevatedButton.icon(
                            key: const Key('profile_submit_button'),
                            onPressed: _submit,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Salvar alterações'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: AppTheme.buttonHeight,
                          child: OutlinedButton.icon(
                            key: const Key('profile_logout_button'),
                            onPressed: () => context.read<AuthCubit>().logout(),
                            icon: const Icon(Icons.logout),
                            label: const Text('Sair'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
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
