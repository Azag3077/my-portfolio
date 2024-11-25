// screens/skills_screen.dart
import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../widgets/skill_badge.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Skill> skills = [
      Skill(name: 'Flutter', iconPath: 'assets/flutter_icon.png'),
      Skill(name: 'Dart', iconPath: 'assets/dart_icon.png'),
      Skill(name: 'Firebase', iconPath: 'assets/firebase_icon.png'),
      Skill(name: 'React', iconPath: 'assets/react_icon.png'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Technical Skills')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return SkillBadge(skill: skills[index]);
        },
      ),
    );
  }
}
