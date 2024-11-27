import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// Project Structure:
// lib/
//   ├── main.dart
//   ├── screens/
//   │   ├── home_screen.dart
//   │   ├── projects_screen.dart
//   │   ├── skills_screen.dart
//   │   └── contact_screen.dart
//   ├── widgets/
//   │   ├── custom_app_bar.dart
//   │   ├── project_card.dart
//   │   └── skill_badge.dart
//   └── models/
//       ├── project.dart
//       └── skill.dart

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agboola Odunayo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
