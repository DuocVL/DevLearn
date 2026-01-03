import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/features/forgot_password/forgot_password_screen.dart';
import 'package:devlearn/features/forgot_password/reset_password_screen.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/lesson_detail/lesson_detail_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/features/register/register_screen.dart';
import 'package:devlearn/features/tutorial_detail/tutorial_detail_screen.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case RouteName.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case RouteName.register:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    case RouteName.forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    case RouteName.resetPassword:
       final email = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email));
    case RouteName.tutorialDetail:
      final tutorialSummary = settings.arguments as TutorialSummary;
      return MaterialPageRoute(builder: (_) => TutorialDetailScreen(tutorialSummary: tutorialSummary));
    case RouteName.lessonDetail:
       final lessonSummary = settings.arguments as LessonSummary;
      return MaterialPageRoute(builder: (_) => LessonDetailScreen(lessonSummary: lessonSummary));
    default:
      return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
  }
}
