import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
// import 'package:cardswop/app/widgets/auth/login_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'testVars.dart';

void main() {
  group('Login', () {
    testWidgets(
      'User won\'t Login with wrong password',
      (tester) async {
        await tester.pumpWidget(Builder(builder: (context) {
          context.read<AuthCubit>().logIn(correctEmail, wrongPassword);

          expect(
              context.read<AuthCubit>().state is UnLoggedWrongPassword, true);
          return const Placeholder();
        }));
      },
    );

    testWidgets(
      'User won\'t Login with wrong password',
      (tester) async {
        await tester.pumpWidget(Builder(builder: (context) {
          context.read<AuthCubit>().logIn(correctEmail, wrongPassword);

          expect(
              context.read<AuthCubit>().state is UnLoggedWrongPassword, true);
          return const Placeholder();
        }));
      },
    );

    testWidgets(
      'User won\'t Login with wrong password',
      (tester) async {
        await tester.pumpWidget(Builder(builder: (context) {
          context.read<AuthCubit>().logIn(correctEmail, wrongPassword);

          expect(
              context.read<AuthCubit>().state is UnLoggedWrongPassword, true);
          return const Placeholder();
        }));
      },
    );
  });
}
