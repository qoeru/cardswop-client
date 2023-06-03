import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop_shared/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key, required this.usernameWithPrefix});

  // final Swopper user;
  final String usernameWithPrefix;

  // final int prefix;

  String convertPrefix() {
    // usernameWithPrefix.replaceAllMapped(, (match) => null)
    return usernameWithPrefix.replaceRange(
        (usernameWithPrefix.length - 5), (usernameWithPrefix.length - 4), '#');
  }

  Widget pageAboutUserNoAuth() {
    return Text('Страница о юзере  ${convertPrefix()}. Вы не вошли в систему.');
  }

  Widget pageAboutOtherUser(String otherUsername, int otherPrefix) {
    return Text(
        'Страница о юзере ${convertPrefix()}. Вы другой юзер, $otherUsername#$otherPrefix.');
  }

  Widget profilePage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Ваше имя:  ${convertPrefix()}'),
          // Text('Ссылка на ваш профиль для других: ')
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                context.read<AuthCubit>().closeAuth();
                context.goNamed('initial');
              },
              child: const Text('Выйти')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserView? user;

    var state = context.read<AuthCubit>().state;
    if (state is LoggedIn) {
      user = state.user;
    }

    if (user == null) {
      return pageAboutUserNoAuth();
    } else if ('${user.name}_${user.suffix}' == usernameWithPrefix) {
      return profilePage(context);
    } else {
      return pageAboutOtherUser(user.name, user.suffix);
    }
  }
}
