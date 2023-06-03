import 'dart:developer';

import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/globals.dart';
import 'package:contextmenu/contextmenu.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            width: ResponsiveBreakpoints.of(context).isDesktop ? 350 : 300,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Вход',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ContextMenuArea(
                    builder: (context) => Globals()
                        .textContextMenuButtons(emailController, context),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле не должно быть пустым';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        // filled: true,
                        labelText: 'Введите свой email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContextMenuArea(
                    builder: (context) => Globals()
                        .textContextMenuButtons(passwordController, context),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Поле не должно быть пустым';
                        }
                        return null;
                      },
                      controller: passwordController,
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
                        border: const OutlineInputBorder(),
                        labelText: 'Введите свой пароль',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthCubit>().logIn(
                            emailController.text, passwordController.text);
                      }
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return LoadingAnimationWidget.waveDots(
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 24);
                        }
                        return const Text(
                          'Войти',
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
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
                    return const SizedBox();
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
