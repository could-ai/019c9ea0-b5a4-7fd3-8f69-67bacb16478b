import 'package:flutter/material.dart';
import 'package:couldai_user_app/exhibition_stand_screen.dart';

void main() {
  runApp(const ExhibitionApp());
}

class ExhibitionApp extends StatelessWidget {
  const ExhibitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxury Exhibition Stand',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft white/grey background
        colorScheme: const ColorScheme.light(
          primary: Colors.black, // Matte black branding
          secondary: Color(0xFF8D7863), // Warm oak/travertine tone
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        fontFamily: 'Arial', // Clean geometry implies sans-serif
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
            height: 1.5,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ExhibitionStandScreen(),
      },
    );
  }
}
