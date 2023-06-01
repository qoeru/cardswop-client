import 'dart:developer';
import 'package:cardswop/app/bloc/cubit/adding_card_cubit.dart';
import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:cardswop/app/pages/logged_page.dart';
import 'package:cardswop/app/pages/unlogged_page.dart';
import 'package:cardswop/app/widgets/about_widget.dart';
import 'package:cardswop/app/widgets/auth/login_widget.dart';
import 'package:cardswop/app/widgets/auth/reg_widget.dart';
import 'package:cardswop/app/widgets/card_widget.dart';
import 'package:cardswop/app/widgets/feed_widget.dart';
import 'package:cardswop/app/widgets/new_card/new_card_desktop_card_widget.dart';
import 'package:cardswop/app/widgets/user_profile_widget.dart';
import 'package:cardswop/config/theme.dart';
// import 'package:cardswop/domain/models/card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

// final GlobalKey<NavigatorState> _loggedNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'logged');
// final GlobalKey<NavigatorState> _unloggedNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'unlogged');

final _router = GoRouter(
  initialLocation: '/',
  // refreshListenable: ,
  routes: [
    ShellRoute(
      // navigatorKey: _unloggedNavigatorKey,
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: UnLoggedPage(
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: '/',
          name: 'initial',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AboutWidget()),
          redirect: (context, state) {
            if (context.read<AuthCubit>().state is LoggedIn ||
                context.read<AuthCubit>().state is LoggedWithoutEmailVerified) {
              return '/feed';
            }
            log(context.read<AuthCubit>().state.toString());
            return null;
          },
          // builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginWidget()),
          redirect: (context, state) {
            if (context.read<AuthCubit>().state is LoggedIn ||
                context.read<AuthCubit>().state is LoggedWithoutEmailVerified) {
              log(context.read<AuthCubit>().state.toString());
              return '/feed';
            }
            log(context.read<AuthCubit>().state.toString());
            return null;
          },
          // builder: (context, state) => const LoginWidget(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RegWidget()),
          redirect: (context, state) {
            if (context.read<AuthCubit>().state is LoggedIn ||
                context.read<AuthCubit>().state is LoggedWithoutEmailVerified) {
              return '/feed';
            }
            log(context.read<AuthCubit>().state.toString());
            return null;
          },
          // builder: (context, state) => RegWidget(),
        ),
      ],
    ),
    ShellRoute(
      // navigatorKey: _loggedNavigatorKey,
      builder: (context, state, child) => LoggedPage(
        child: child,
      ),
      routes: [
        GoRoute(
          // parentNavigatorKey: _loggedNavigatorKey,
          name: 'feed',
          path: '/feed',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Placeholder());
          },

          // redirect: (context, state) {
          //   if (context.read<AuthCubit>().state is! LoggedIn &&
          //       context.read<AuthCubit>().state
          //           is! LoggedWithoutEmailVerified) {
          //     return '/';
          //   }
          //   return null;
          // },
          // builder: (context, state) => HomeWidget(),
          routes: [
            GoRoute(
              name: 'card',
              path: ':cardId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const Placeholder(),

                // child: CardWidget(
                //     // cardId: state.pathParameters['cardId']!,
                //     card: state.extra as SwopCard),
              ),
              redirect: (context, state) {
                if (context.read<AuthCubit>().state is! LoggedIn &&
                    context.read<AuthCubit>().state
                        is! LoggedWithoutEmailVerified) {
                  return '/';
                }
                return null;
              },
            )
          ],
          redirect: (context, state) {
            if (context.read<AuthCubit>().state is! LoggedIn &&
                context.read<AuthCubit>().state
                    is! LoggedWithoutEmailVerified) {
              return '/';
            }
            return null;
          },
        ),
        GoRoute(
          // parentNavigatorKey: _loggedNavigatorKey,
          path: '/newcard',
          name: 'newcard',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const Placeholder(),
            // child: NewCardMaterialCardWidget(),
          ),
          redirect: (context, state) {
            if (context.read<AuthCubit>().state is! LoggedIn &&
                context.read<AuthCubit>().state
                    is! LoggedWithoutEmailVerified) {
              return '/login';
            }
            return null;
          },
        ),
        GoRoute(
          // parentNavigatorKey: _loggedNavigatorKey,
          path: '/:userId', // with underscrore instead of #
          name: 'user',
          pageBuilder: (context, state) => NoTransitionPage(
            child: UserProfileWidget(
              usernameWithPrefix: state
                  .pathParameters['userId']!, // with underscrore instead of #
            ),
          ),
        ),
      ],
    ),
  ],
);

void main() async {
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AuthCubit(),
        ),
        // BlocProvider(
        //   create: (context) => NavigationCubit()..onStartUpNavigation(),
        // ),
        // BlocProvider(
        //   create: (context) => AddingCardCubit(),
        // ),
      ],
      child: const CardSwopApp(),
    ),
  );
}

class CardSwopApp extends StatelessWidget {
  const CardSwopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: MOBILE),
          const Breakpoint(start: 601, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
          // const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: const BaseTheme().toThemeData(),
    );
  }
}
