import 'package:devlearn/screens/home/home_screen.dart';
import 'package:devlearn/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DevLearnApp extends StatelessWidget {
  const DevLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'DevLearn',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      //TODO: Route
      home: const HomeScreen(),
    );
  }
}