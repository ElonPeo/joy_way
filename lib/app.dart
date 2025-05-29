import 'package:flutter/material.dart';
import 'package:joy_way/screens/WelcomeScreen.dart';
import 'config/Theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
      },
    );
  }
}
