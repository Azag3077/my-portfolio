// widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Agboola Odunayo | Portfolio'),
      centerTitle: true,
      actions: [
        TextButton(
          child: const Text('Home'),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        TextButton(
          child: const Text('Projects'),
          onPressed: () {
            // Navigate to Projects Screen
          },
        ),
        TextButton(
          child: const Text('Skills'),
          onPressed: () {
            // Navigate to Skills Screen
          },
        ),
        TextButton(
          child: const Text('Contact'),
          onPressed: () {
            // Navigate to Contact Screen
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
