import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:cardswop/presentation/bloc/cubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggedPage extends StatefulWidget {
  const LoggedPage(
      {super.key, required this.child, required this.selectedIndex});
  final Widget child;
  final int selectedIndex;

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

  int? selectedDestination;

  @override
  Widget build(BuildContext context) {
    selectedDestination = selectedDestination ?? widget.selectedIndex;

    return AdaptiveScaffold(
      useDrawer: false,
      internalAnimations: false,
      selectedIndex: selectedDestination,
      // trailingNavRail: widget.addCardButton(context),
      smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
      mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
      largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
      // useDrawer: true,
      onSelectedIndexChange: (p0) {
        setState(() {
          selectedDestination = p0;

          if (selectedDestination == 0) {
            context.goNamed('feed');
          }
          if (selectedDestination == 1) {
            var state = context.read<AuthCubit>().state;
            if (state is LoggedIn) {
              String userId = '${state.user.name}_${state.user.suffix}';
              context.goNamed('user', pathParameters: {'userId': userId});
            }
          }
          if (selectedDestination == 2) {
            context.goNamed('about');
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
          icon: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            if (state is LoggedIn && state.isEmailVerified == false) {
              return Badge(label: const Text('!'), child: LineIcon.user());
            } else {
              return LineIcon.user();
            }
          }),
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
