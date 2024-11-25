// screens/projects_screen.dart
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Project> projects = [
      Project(
        title: 'E-Commerce App',
        description: 'Full-featured mobile shopping application',
        technologies: 'Flutter, Firebase, Provider',
        githubLink: 'https://github.com/example/ecommerce',
        imageUrl: 'https://via.placeholder.com/300',
      ),
      Project(
        title: 'Task Management System',
        description: 'Collaborative project management tool',
        technologies: 'Flutter, GraphQL, AWS Amplify',
        githubLink: 'https://github.com/example/taskmgr',
        imageUrl: 'https://via.placeholder.com/300',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return ProjectCard(project: projects[index]);
        },
      ),
    );
  }
}
