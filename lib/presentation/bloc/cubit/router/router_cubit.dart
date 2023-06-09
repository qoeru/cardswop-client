// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';

import 'package:cardswop/presentation/pages/logged_page.dart';
import 'package:cardswop/presentation/pages/unlogged_page.dart';
import 'package:cardswop/presentation/widgets/about_widget.dart';
import 'package:cardswop/presentation/widgets/auth/login_widget.dart';
import 'package:cardswop/presentation/widgets/auth/reg_widget.dart';
import 'package:cardswop/presentation/widgets/card_widget.dart';
import 'package:cardswop/presentation/widgets/feed_widget.dart';
import 'package:cardswop/presentation/widgets/new_card_widget.dart';
import 'package:cardswop/presentation/widgets/user_profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'router_state.dart';

class RouterCubit extends Cubit<RouterState> {
  RouterCubit(this.authCubit) : super(RouterInitial());

  final AuthCubit authCubit;

  final GlobalKey<NavigatorState> _unloggedNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'unlogged');
  final GlobalKey<NavigatorState> _loggedNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'logged');

  late final GoRouter router = GoRouter(
    refreshListenable: authCubit,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _unloggedNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: UnLoggedPage(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser != null) {
                return '/feed';
              }
              return '/login';
            },
          ),
          GoRoute(
            path: '/login',
            name: 'login',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: LoginWidget());
            },
            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser != null) {
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
              return const NoTransitionPage(child: RegWidget());
            },
            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser != null) {
                return '/feed';
              }
              return null;
            },
            // builder: (context, state) => RegWidget(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _loggedNavigatorKey,
        pageBuilder: (context, state, child) => NoTransitionPage(
          // child: Placeholder(),
          child: LoggedPage(
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/about',
            name: 'about',
            pageBuilder: (context, state) {
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
              return const NoTransitionPage(child: FeedWidget());
            },

            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser == null) {
                return '/';
              }
              return null;
            },
            routes: [
              GoRoute(
                name: 'card',
                path: 'card=:cardId',
                pageBuilder: (context, state) => NoTransitionPage(
                  // child: Placeholder(),

                  child: CardPage(
                    cardId: state.pathParameters['cardId']!,
                  ),
                ),
              )
            ],
          ),
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/newcard',
            name: 'newcard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NewCardWidget(),
              // child: Placeholder()
              // child: NewCardMaterialCardWidget(),
              // child: NewCardMaterialCardWidget(),
            ),
            redirect: (context, state) {
              if (FirebaseAuth.instance.currentUser == null) {
                return '/login';
              }
              return null;
            },
          ),
          GoRoute(
            // parentNavigatorKey: _loggedNavigatorKey,
            path: '/user',
            name: 'user',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                // child: Placeholder(),
                child: UserProfileWidget(
                  username: state.queryParameters['username']!,
                  suffix: int.parse(state.queryParameters['suffix']!),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
