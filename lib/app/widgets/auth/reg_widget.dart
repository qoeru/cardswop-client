import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class RegWidget extends StatefulWidget {
  const RegWidget({super.key});

  @override
  State<RegWidget> createState() => _RegWidgetState();
}

class _RegWidgetState extends State<RegWidget> {
  String? password;
  String? name;
  String? email;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    bool loading = false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TypographyTitle(
            'Регистрация',
            level: 3,
          ),
          const SizedBox(height: 20),
          Input(
            value: name,
            placeholder: 'Введите свой юзернейм',
          ),
          const SizedBox(
            height: 10,
          ),
          Input(
            value: email,
            placeholder: 'Введите свой email',
          ),
          const SizedBox(height: 10),
          Input(
            value: password,
            addonAfter: Button(
                onClick: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: showPassword
                    ? const Icon(
                        Ionicons.eye,
                      )
                    : const Icon(Ionicons.eye_off)),
          ),
          const SizedBox(height: 20),
          Button(
            loading: loading,
            onClick: () {
              loading = true;
              context.read<AuthCubit>().tryToRegister(name!, email!, password!);
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
    );
  }
}
