import 'package:bloc_test/bloc_test.dart';
import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/pages/auth/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('UserProfilePage', () {
    late MockAuthCubit authCubit;
    late UserEntity user;

    setUp(() {
      authCubit = MockAuthCubit();
      user = UserEntity(
        id: '1',
        name: 'Vinicius',
        email: 'user@example.com',
        passwordHash: 'hash',
        salt: 'salt',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      when(() => authCubit.currentUser).thenReturn(user);
      when(() => authCubit.state).thenReturn(AuthAuthenticated(user));
      whenListen(authCubit, const Stream<AuthState>.empty(),
          initialState: AuthAuthenticated(user));
    });

    testWidgets('prefills form with current user data and submits updates',
        (tester) async {
      when(() => authCubit.updateProfile(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: const UserProfilePage(),
          ),
        ),
      );

      expect(find.text('Vinicius'), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('profile_name_field')), 'Novo Nome');
      await tester.enterText(
          find.byKey(const Key('profile_email_field')), 'novo@example.com');
      await tester.enterText(
          find.byKey(const Key('profile_password_field')), 'novaSenha');
      await tester.enterText(
          find.byKey(const Key('profile_confirm_field')), 'novaSenha');

      await tester.tap(find.byKey(const Key('profile_submit_button')));
      await tester.pump();

      verify(() => authCubit.updateProfile(
            name: 'Novo Nome',
            email: 'novo@example.com',
            password: 'novaSenha',
          )).called(1);
    });
  });
}
