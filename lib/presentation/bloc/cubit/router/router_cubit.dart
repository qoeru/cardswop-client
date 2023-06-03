// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:cardswop/presentation/pages/logged_page.dart';
import 'package:cardswop/presentation/pages/unlogged_page.dart';
import 'package:cardswop/presentation/widgets/about_widget.dart';
import 'package:cardswop/presentation/widgets/auth/login_widget.dart';
import 'package:cardswop/presentation/widgets/auth/reg_widget.dart';
import 'package:cardswop/presentation/widgets/user_profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit({required this.authCubit}) : super(RouterInitial());

  final AuthCubit authCubit;

  int _selectedDestinationUnlogged = 0;
  int _selectedDestinationLogged = 0;

  late final GoRouter router = GoRouter(
    refreshListenable: authCubit,
    initialLocation: '/',
    routes: [
      ShellRoute(
        // navigatorKey: _unloggedNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: UnLoggedPage(
              selectedIndex: _selectedDestinationUnlogged,
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'initial',
            pageBuilder: (context, state) {
              _selectedDestinationUnlogged = 0;
              return const NoTransitionPage(child: AboutWidget());
            },
            redirect: (context, state) {
              if (authCubit.state is LoggedIn) {
                return '/feed';
              }
              return null;
            },
            // builder: (context, state) => const Placeholder(),
          ),
          GoRoute(
            path: '/login',
            name: 'login',
            pageBuilder: (context, state) {
              _selectedDestinationUnlogged = 1;
              return const NoTransitionPage(child: LoginWidget());
            },
            redirect: (context, state) {
              if (authCubit.state is LoggedIn) {
                return '/feed';
              }
              return null;
            },
            // builder: (context, state) => const LoginWidget(),
          ),
          GoRoute(
            path: '/register',
            name: 'register',
            pageBuilder: (context, state) {
              _selectedDestinationUnlogged = 2;
              return NoTransitionPage(child: RegWidget());
            },
            redirect: (context, state) {
              if (authCubit.state is LoggedIn) {
                return '/feed';
              }
              return null;
            },
            // builder: (context, state) => RegWidget(),
          ),
        ],
      ),
      ShellRoute(
        // navigatorKey: _loggedNavigatorKey,
        builder: (context, state, child) => LoggedPage(
          selectedIndex: _selectedDestinationLogged,
          child: child,
        ),

        routes: [
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/about',
            name: 'about',
            pageBuilder: (context, state) {
              _selectedDestinationLogged = 2;

              return const NoTransitionPage(
                child: Placeholder(), // with underscrore instead of #
              );
            },
          ),
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            name: 'feed',
            path: '/feed',
            pageBuilder: (context, state) {
              _selectedDestinationLogged = 0;
              return const NoTransitionPage(child: Placeholder());
            },

            redirect: (context, state) {
              _selectedDestinationUnlogged = 0;
              if (authCubit.state is! LoggedIn) {
                return '/';
              }
              return null;
            },
            routes: [
              GoRoute(
                name: 'card',
                path: ':cardId',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: Placeholder(),

                  // child: CardWidget(
                  //     // cardId: state.pathParameters['cardId']!,
                  //     card: state.extra as SwopCard),
                ),
              )
            ],
          ),
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/newcard',
            name: 'newcard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: Placeholder(),
              // child: NewCardMaterialCardWidget(),
            ),
            redirect: (context, state) {
              if (authCubit.state is! LoggedIn) {
                return '/login';
              }
              return null;
            },
          ),
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/:userId', // with underscrore instead of #
            name: 'user',
            pageBuilder: (context, state) {
              _selectedDestinationLogged = 2;
              return NoTransitionPage(
                child: UserProfileWidget(
                  usernameWithPrefix: state.pathParameters[
                      'userId']!, // with underscrore instead of #
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
