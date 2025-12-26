import 'package:devlearn/theme/app_theme.dart';
import 'package:devlearn/routes/app_route.dart';
import 'package:devlearn/routes/route_name.dart';
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
      routes: AppRoute.routes,
      initialRoute: RouteName.login,
    );
  }
}