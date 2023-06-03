// ignore: unused_import
import 'dart:developer';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/presentation/bloc/cubit/router/router_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AuthCubit authCubit = AuthCubit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
            lazy: false, create: (context) => authCubit..checkAuthStatus()),
        BlocProvider(create: (context) => RouterCubit(authCubit: authCubit))
      ],
      child: const CardSwopApp(),
    ),
  );
}

class CardSwopApp extends StatelessWidget {
  const CardSwopApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter router = context.read<RouterCubit>().router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 700, name: MOBILE),
            const Breakpoint(start: 701, end: 1000, name: TABLET),
            const Breakpoint(start: 1001, end: double.infinity, name: DESKTOP),
            // const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      routerConfig: router,
      theme: const BaseTheme().toThemeData(true),
    );
  }
}
