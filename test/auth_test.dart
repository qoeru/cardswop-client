import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_vars.dart';

void main() {
  AuthCubit authCubit = AuthCubit();

  group('Register', () {
    test('User will register with correct data', () {
      authCubit.tryToRegister(
          'someUserName', unregisteredEmailWhichExists, password);
      expect(authCubit.state, LoggedIn);
    });
  });

  group('Login', () {
    test('User will Log In without their email yet verified', () {
      authCubit.logIn(registeredEmail, password);
      expect(authCubit.state, LoggedIn);
    });
  });
}
