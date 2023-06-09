import 'dart:developer';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(
                BorderSide(color: Theme.of(context).colorScheme.outline))),
        width: 350,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Вход',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  FilledButton(
                      onPressed: () {
                        context.goNamed('register');
                      },
                      child: const Text('Регистрация')),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Поле не должно быть пустым';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(label: Text('email'))),
              const Divider(),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не должно быть пустым';
                  }
                  return null;
                },
                obscureText: !showPassword,
                controller: passwordController,
                decoration: InputDecoration(
                    label: const Text('Пароль'),
                    isCollapsed: true,
                    isDense: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? const Icon(
                                EvaIcons.eyeOutline,
                                // size: 16,
                              )
                            : const Icon(
                                EvaIcons.eyeOff2Outline,
                                // size: ,
                              ))),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context
                        .read<AuthCubit>()
                        .logIn(emailController.text, passwordController.text);
                  }
                },
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Text(
                      'Войти',
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(EvaIcons.googleOutline),
                    label: const Text('Google'),
                  ),
                  const Text('или'),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(EvaIcons.personOutline),
                    label: const Text('VK'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
                if (state is LoggedIn) {
                  log('Logged inn!!');
                  context.goNamed('feed');
                }
              }, builder: (context, state) {
                if (state is UnLoggedUserNotFound) {
                  return const Text('Пользователь не найден');
                }
                if (state is UnLoggedWrongPassword) {
                  return const Text('Неверный пароль');
                }
                if (state is UnLoggedError) {
                  return const Text('Неизвестная ошибка');
                }
                if (state is UnLoggedInvalidEmail) {
                  return const Text('Неверный формат почты');
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
