import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class RegWidget extends StatefulWidget {
  const RegWidget({super.key});

  @override
  State<RegWidget> createState() => _RegWidgetState();
}

class _RegWidgetState extends State<RegWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ResponsiveBreakpoints.of(context).isDesktop ? 350 : 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Регистрация',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Юзернейм')),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Почта')),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым';
                }
                return null;
              },
              obscureText: !showPassword,
              decoration: InputDecoration(
                // filled: true,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: showPassword
                        ? const Icon(
                            Icons.visibility_outlined,
                          )
                        : const Icon(Icons.visibility_off_rounded)),
                border: OutlineInputBorder(),
                labelText: 'Введите свой пароль',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                context.read<AuthCubit>().tryToRegister(usernameController.text,
                    emailController.text, passwordController.text);
              },
              child: const Text('Создать аккаунт'),
            ),

            // const SizedBox(height: 10),
            // OutlinedButton.icon(
            //   icon: const Icon(EvaIcons.googleOutline),
            //   onPressed: () {},
            //   style:
            //       ButtonStyle(minimumSize: MaterialStateProperty.all(Size(0, 45))),
            //   label: const Text('Войти с помощью Google'),
            // ),
            // const SizedBox(height: 10),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoggedIn || state is LoggedWithoutEmailVerified) {
                  // context.goNamed('feed');
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LoggedPage()));
                  // BlocProvider.of<NavigationCubit>(context)
                  //     .switchToHome();
                }
              },
              builder: (context, state) {
                if (state is RegFailedEmailExist) {
                  return const Text('Аккаунт с данной почтой уже существует');
                }
                if (state is RegFailed) {
                  return const Text('Ошибка: некорректные данные');
                }
                if (state is RegFailedUsernameExists) {
                  return const Text('Аккаунт с данным именем уже существует');
                }
                if (state is RegFailedWeakPassword) {
                  return const Text('Слишком слабый пароль');
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
