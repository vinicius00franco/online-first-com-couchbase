import 'package:bloc_test/bloc_test.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('RegisterPage', () {
    late MockAuthCubit authCubit;

    setUp(() {
      authCubit = MockAuthCubit();
      when(() => authCubit.state).thenReturn(const AuthUnauthenticated());
      whenListen(authCubit, const Stream<AuthState>.empty());
    });

    testWidgets('calls register when form is submitted', (tester) async {
      when(() => authCubit.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: RegisterPage(onNavigateToLogin: () {}),
          ),
        ),
      );

      await tester.enterText(
          find.byKey(const Key('register_name_field')), 'Vinicius');
      await tester.enterText(
          find.byKey(const Key('register_email_field')), 'user@example.com');
      await tester.enterText(
          find.byKey(const Key('register_password_field')), 'secret123');
      await tester.enterText(
          find.byKey(const Key('register_confirm_field')), 'secret123');

      await tester.tap(find.byKey(const Key('register_submit_button')));
      await tester.pump();

      verify(() => authCubit.register(
            name: 'Vinicius',
            email: 'user@example.com',
            password: 'secret123',
          )).called(1);
    });

    testWidgets('navigates back to login when link is tapped', (tester) async {
      var navigated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: RegisterPage(
              onNavigateToLogin: () {
                navigated = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('register_login_button')));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
    });
  });
}
