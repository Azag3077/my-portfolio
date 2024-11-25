// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Portfolio Landing Page',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LandingPage(),
//     );
//   }
// }
//
// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red,
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage('https://via.placeholder.com/1500x1000'),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   Colors.black.withOpacity(0.6),
//                   BlendMode.darken,
//                 ),
//               ),
//             ),
//           ),
//
//           // Content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Profile Picture
//                 CircleAvatar(
//                   radius: 100,
//                   backgroundImage:
//                       NetworkImage('https://via.placeholder.com/200'),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Name
//                 Text(
//                   'John Doe',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 48,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 // Subtitle
//                 Text(
//                   'Software Engineer | Web & Mobile Developer',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 20,
//                   ),
//                 ),
//
//                 SizedBox(height: 40),
//
//                 // Social Links
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildSocialButton(Icons.link, 'Portfolio'),
//                     SizedBox(width: 20),
//                     _buildSocialButton(Icons.mail, 'Contact'),
//                     SizedBox(width: 20),
//                     _buildSocialButton(Icons.code, 'GitHub'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSocialButton(IconData icon, String text) {
//     return ElevatedButton.icon(
//       icon: Icon(icon, color: Colors.white),
//       label: Text(
//         text,
//         style: TextStyle(color: Colors.white),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black54,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       onPressed: () {
//         // TODO: Add navigation or action for each button
//       },
//     );
//   }
// }

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

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Software Engineer Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
