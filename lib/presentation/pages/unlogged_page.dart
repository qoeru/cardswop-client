import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

class UnLoggedPage extends StatefulWidget {
  const UnLoggedPage(
      {super.key, required this.child, required this.selectedIndex});
  final Widget child;

  final int selectedIndex;

  @override
  State<UnLoggedPage> createState() => _UnLoggedPageState();
}

class _UnLoggedPageState extends State<UnLoggedPage> {
  int? selectedDestination;
  @override
  Widget build(BuildContext context) {
    selectedDestination = selectedDestination ?? widget.selectedIndex;
    return AdaptiveScaffold(
      internalAnimations: false,
      smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
      mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
      largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
      useDrawer: false,
      onSelectedIndexChange: (p0) {
        setState(() {
          selectedDestination = p0;

          if (selectedDestination == 0) {
            context.goNamed('initial');
          }
          if (selectedDestination == 1) {
            context.goNamed('login');
          }
          if (selectedDestination == 2) {
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
      selectedIndex: selectedDestination,

      smallBody: (_) => Card(
        key: const Key('Navigation Compact'),
        color: Theme.of(context).colorScheme.surface,
        child: widget.child,
      ),
      largeBody: (cntxt) => Padding(
        key: const Key('Navigation Desktop'),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            SizedBox(
              width: 360,
              child: Card(
                // margin: const EdgeInsets.all(24),

                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: const Center(
                  child: Text('Надо потом сюда что-то добавить'),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Card(
                // margin: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.surface,
                child: widget.child,
              ),
            )
          ],
        ),
      ),

      body: (_) => Padding(
        key: const Key('Navigation Medium'),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Card(
                // margin: const EdgeInsets.all(24),
                // width: 360,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: const Center(
                  child: Text('Надо потом сюда что-то добавить'),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Card(
                // margin: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.surface,
                child: widget.child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
