

// widgets/skill_badge.dart
import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillBadge extends StatelessWidget {
  final Skill skill;

  const SkillBadge({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            skill.iconPath,
            width: 64,
            height: 64,
          ),
          const SizedBox(height: 10),
          Text(
            skill.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}