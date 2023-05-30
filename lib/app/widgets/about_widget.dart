import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Страница с информацией??',
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
