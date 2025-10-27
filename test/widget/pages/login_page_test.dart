import 'package:bloc_test/bloc_test.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  group('LoginPage', () {
    late MockAuthCubit authCubit;

    setUp(() {
      authCubit = MockAuthCubit();
      when(() => authCubit.state).thenReturn(const AuthUnauthenticated());
      whenListen(authCubit, const Stream<AuthState>.empty());
    });

    testWidgets('calls login when form is submitted', (tester) async {
      when(() => authCubit.login(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: LoginPage(
              onNavigateToRegister: () {},
            ),
          ),
        ),
      );

      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'user@example.com');
      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'secret123');

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();

      verify(() =>
              authCubit.login(email: 'user@example.com', password: 'secret123'))
          .called(1);
    });

    testWidgets('navigates to register page when link tapped', (tester) async {
      bool navigated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: authCubit,
            child: LoginPage(
              onNavigateToRegister: () {
                navigated = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('login_register_button')));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
    });
  });
}
