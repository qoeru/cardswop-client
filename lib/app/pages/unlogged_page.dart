import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:responsive_framework/responsive_breakpoints.dart';

class UnLoggedPage extends StatefulWidget {
  const UnLoggedPage({super.key, required this.child});
  final Widget child;

  @override
  State<UnLoggedPage> createState() => _UnLoggedPageState();
}

class _UnLoggedPageState extends State<UnLoggedPage> {
  // int _selectedIndex;

  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
      mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
      largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
      useDrawer: false,
      onSelectedIndexChange: (p0) {
        setState(() {
          _selectedDestination = p0;

          if (_selectedDestination == 0) {
            context.goNamed('initial');
          }
          if (_selectedDestination == 1) {
            context.goNamed('login');
          }
          if (_selectedDestination == 2) {
            context.goNamed('register');
          }
        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Главная'),
        NavigationDestination(icon: Icon(Icons.login_rounded), label: 'Вход'),
        NavigationDestination(
            icon: Icon(Icons.person_add_rounded), label: 'Регистрация'),
      ],

      // largeBody: (_) => ,
      selectedIndex: _selectedDestination,

      smallBody: (_) => Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: widget.child,
      ),
      largeBody: (cntxt) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              // margin: const EdgeInsets.all(24),
              width: 360,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Center(
                child: Text('Надо потом сюда что-то добавить'),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Container(
                // margin: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: widget.child,
              ),
            )
          ],
        ),
      ),

      body: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Container(
                // margin: const EdgeInsets.all(24),
                // width: 360,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Center(
                  child: Text('Надо потом сюда что-то добавить'),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Container(
                // margin: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: widget.child,
              ),
            )
          ],
        ),
      ),
    );
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
