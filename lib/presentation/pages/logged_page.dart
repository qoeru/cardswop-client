import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoggedPage extends StatefulWidget {
  const LoggedPage({super.key, required this.child});

  final Widget child;

  @override
  State<LoggedPage> createState() => _LoggedPageState();
}

class _LoggedPageState extends State<LoggedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реестр'),
        actions: [
          TextButton(
              onPressed: () {
                context.goNamed(
                  'feed',
                );
              },
              child: const Text('Лента')),
          TextButton(
              onPressed: () {
                var state = context.read<AuthCubit>().state;
                if (state is LoggedIn) {
                  context.goNamed('user', queryParameters: {
                    'username': state.user.name,
                    'suffix': state.user.suffix.toString(),
                  });
                }
              },
              child: const Text('Профиль')),
        ],
      ),
      body: SafeArea(
        child: widget.child,
      ),
    );
  }
}
