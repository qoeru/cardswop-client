import 'package:cardswop/app/bloc/cubit/auth_cubit.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

// import 'package:responsive_framework/responsive_breakpoints.dart';

class LoggedPage extends StatefulWidget {
  const LoggedPage({super.key, required this.child});
  final Widget child;

  Widget addCardButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.goNamed('newcard');
      },
      child: LineIcon.plus(),
    );
  }

  @override
  State<LoggedPage> createState() => _LoggedPageState();
}

class _LoggedPageState extends State<LoggedPage> {
  // int _selectedIndex;

  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    bool isEmailVerified = context.read<AuthCubit>().isEmailVerified!;

    return AdaptiveScaffold(
      selectedIndex: _selectedDestination,
      trailingNavRail: widget.addCardButton(context),
      smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
      mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
      largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
      // useDrawer: true,
      onSelectedIndexChange: (p0) {
        setState(() {
          _selectedDestination = p0;

          if (_selectedDestination == 0) {
            context.goNamed('feed');
          }
          if (_selectedDestination == 1) {
            context.goNamed('user');
          }
          if (_selectedDestination == 2) {
            context.goNamed('initial');
          }
        });
      },
      destinations: [
        NavigationDestination(
          icon: LineIcon.home(),
          label: 'Главная',
          // tooltip: 'adsasd',
        ),
        NavigationDestination(
          icon: Badge(
              isLabelVisible: !isEmailVerified,
              label: const Text('!'),
              child: LineIcon.user()),
          label: 'Профиль',
          // tooltip: 'adsads',
        ),
        NavigationDestination(icon: LineIcon.question(), label: 'FAQ'),
      ],
      smallBody: (_) => Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: widget.child,
      ),
      largeBody: (cntxt) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            SizedBox(
              // margin: const EdgeInsets.all(24),
              width: 360,
              child: Card(
                child: Center(
                  child: Image.asset('assets/Icon-192.png'),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Card(
                // margin: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
      body: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Expanded(
              child: Card(
                child: Center(
                  child: Text('Надо потом сюда что-то добавить'),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: Card(
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
