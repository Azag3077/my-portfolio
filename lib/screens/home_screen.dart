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
          children: <Widget>[
            // Hero Section
            Container(
              height: 500,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Color(0xFF2563eb),
                  Color(0xFF1e40af),
                ]),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 128,
                      backgroundColor: Color(0xFF60A5FA),
                      backgroundImage: AssetImage(
                        'assets/images/azag.jpg',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Agboola Odunayo',
                      style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Software Developer | Flutter Specialist | Python Backend',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
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
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProjectsScreen())),
                    child: const Text('Projects'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SkillsScreen())),
                    child: const Text('Skills'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ContactScreen())),
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
