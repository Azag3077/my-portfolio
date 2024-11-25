

// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'projects_screen.dart';
import 'skills_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.blue[50],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/200',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Jane Doe',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Software Engineer | Flutter Specialist',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Links
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProjectsScreen())
                    ),
                    child: const Text('Projects'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SkillsScreen())
                    ),
                    child: const Text('Skills'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ContactScreen())
                    ),
                    child: const Text('Contact'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}