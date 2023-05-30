import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class UnLoggedPage extends StatefulWidget {
  const UnLoggedPage({super.key, required this.child});
  final Widget child;

  @override
  State<UnLoggedPage> createState() => _UnLoggedPageState();
}

class _UnLoggedPageState extends State<UnLoggedPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //     title: Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: TextButton.icon(
        //           label: Text('КАРДСВОП РЕЕСТР'),
        //           onPressed: () {
        //             context.goNamed('initial');
        //             // context.read<NavigationCubit>().switchToHome();
        //           },
        //           icon: const Icon(Icons.home_rounded)),
        //     ),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           context.goNamed('login');
        //           // context.read<NavigationCubit>().switchToLogin();
        //         },
        //         child: const Text('Вход'),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           context.goNamed('register');
        //         },
        //         child: const Text('Регистрация'),
        //       ),
        //       if (ResponsiveBreakpoints.of(context).isDesktop)
        //         const SizedBox(
        //           width: 50,
        //         )
        //     ]),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SlotLayout(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavigationRail(
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedIndex = value;

                      if (_selectedIndex == 0) {
                        context.goNamed('initial');
                      }
                      if (_selectedIndex == 1) {
                        context.goNamed('login');
                      }
                      if (_selectedIndex == 2) {
                        context.goNamed('register');
                      }
                    });
                  },
                  labelType: NavigationRailLabelType.none,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home_rounded), label: Text('Главная')),
                    NavigationRailDestination(
                        icon: Icon(Icons.login_rounded), label: Text('Вход')),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_add_rounded),
                        label: Text('Регистрация')),
                  ],
                  selectedIndex: _selectedIndex),
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: widget.child,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//

class VerificationBanner extends StatefulWidget {
  const VerificationBanner({super.key});

  @override
  State<VerificationBanner> createState() => _VerificationBannerState();
}

class _VerificationBannerState extends State<VerificationBanner> {
  bool? _isVisible;
  @override
  void initState() {
    _isVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainAnimation: true,
      visible: _isVisible!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width < 601)
                      ? MediaQuery.of(context).size.width / 7
                      : MediaQuery.of(context).size.width - 556,
                  child: Text(
                      'Ваша почта не подтверждена. На указанный вами email было отправлено письмо с ссылкой для подтверждения, пожалуйста подтвердите свой почтовый адрес.'),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },
                    child: const Text('Позже')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      context.read<AuthCubit>().emitEmailVerification();
                      _isVisible = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Письмо отослано!'),
                          action: SnackBarAction(
                            label: 'Понятно',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          )));
                    });
                  },
                  child: const Text('Выслать подтверждение еще раз'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class VerificationBanner extends StatelessWidget {
//   const VerificationBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: (MediaQuery.of(context).size.width < 601)
//                     ? MediaQuery.of(context).size.width / 7
//                     : MediaQuery.of(context).size.width - 556,
//                 child: Text(
//                     'Ваша почта не подтверждена. На указанный вами email было отправлено письмо с ссылкой для подтверждения, пожалуйста подтвердите свой почтовый адрес.'),
//               ),
//               TextButton(
//                   onPressed: () {
//                     isVisible = false;
//                   },
//                   child: const Text('Позже')),
//               TextButton(
//                 onPressed: () {
//                   context.read<AuthCubit>().emitEmailVerification();
//                   isVisible = false;
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: const Text('Письмо отослано!'),
//                       action: SnackBarAction(
//                         label: 'Понятно',
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                         },
//                       )));
//                 },
//                 child: const Text('Выслать подтверждение еще раз'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
