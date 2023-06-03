import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/globals.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
// import 'package:cardswop/globals.dart' as globals;

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ContextMenuArea(
      verticalPadding: 8,
      builder: (context) =>
          Globals().textContextMenuButtons(widget.passwordController, context),
      child: TextFormField(
        controller: widget.passwordController,
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
          border: const OutlineInputBorder(),
          labelText: 'Введите свой пароль',
        ),
      ),
    );
  }
}

class RegWidget extends StatelessWidget {
  RegWidget({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Widget textFormField(String label, TextEditingController editingController) {
    return ContextMenuArea(
      builder: (context) =>
          Globals().textContextMenuButtons(editingController, context),
      child: TextFormField(
        contextMenuBuilder: null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Поле не должно быть пустым';
          }
          return null;
        },
        // textInputAction: ,

        controller: editingController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), label: Text(label)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Center(
      child: Card(
        child: Container(
          width: ResponsiveBreakpoints.of(context).isDesktop ? 350 : 300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Регистрация',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 24),
                textFormField('Юзернейм', usernameController),
                const SizedBox(
                  height: 8,
                ),
                textFormField('Email', emailController),

                const SizedBox(height: 8),
                PasswordField(passwordController: passwordController),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthCubit>().tryToRegister(
                          usernameController.text,
                          emailController.text,
                          passwordController.text);
                    }
                  },
                  child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                    if (state is RegLoading) {
                      return LoadingAnimationWidget.waveDots(
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24);
                    }
                    return const Text(
                      'Создать аккаунт',
                    );
                  }),
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
                    if (state is LoggedIn) {
                      context.goNamed('feed');
                    }
                  },
                  builder: (context, state) {
                    if (state is RegFailedEmailExist) {
                      return const Text(
                          'Аккаунт с данной почтой уже существует');
                    }
                    if (state is RegFailed) {
                      return const Text('Ошибка: некорректные данные');
                    }
                    if (state is RegFailedUsernameExists) {
                      return const Text(
                          'Аккаунт с данным именем уже существует');
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
        ),
      ),
    );
  }
}
