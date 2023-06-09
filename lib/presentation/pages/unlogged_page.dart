import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnLoggedPage extends StatelessWidget {
  const UnLoggedPage({super.key, required this.child});

  final Widget child;

  Widget rulesColumn(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 200,
      child: Column(
        children: [
          Text(
            'Правила',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text(
              'sdfhkdsjhkdsjhdsfjkhsdjkfhkjfdsahsdjkhadfjkshjksdfhjksadhasjkfhjkahkjlfadshjdsfkfhkjlfdahjkdsfhdsafjkladsk'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реестр'),
      ),
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            rulesColumn(context),
            const VerticalDivider(),
            Expanded(child: child)
          ],
        ),
      ),
    );
  }
}
