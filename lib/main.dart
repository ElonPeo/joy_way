import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joy_way/AuthWrapper.dart';
import 'package:joy_way/screens/HomeScreen/HomeScreen.dart';
import 'package:joy_way/screens/WelcomeScreen.dart';
import 'config/Theme.dart';
import 'firebase_options.dart';
import 'screens/authentication/components/FoundationOfAuth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: AppTheme.themeData,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) =>  FoundationOfAuth(),
        '/home': (context) => const HomeScreen(),
        '/welcome': (context) =>  WelcomeScreen(),
      },
    );
  }
}
