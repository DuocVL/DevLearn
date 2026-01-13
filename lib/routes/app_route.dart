import 'package:devlearn/features/forgot_password/forgot_password_screen.dart';
import 'package:devlearn/features/forgot_password/reset_password_screen.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/lesson_detail/lesson_detail_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/features/post/create_post_screen.dart';
import 'package:devlearn/features/register/register_screen.dart';
import 'package:devlearn/features/splash/splash_screen.dart';
import 'package:devlearn/features/tutorial_detail/tutorial_detail_screen.dart';
import 'package:flutter/material.dart';
// SỬA LỖI: Thay đổi import sai
import '../data/models/lesson.dart'; 
import '../data/models/tutorial_summary.dart';
import 'route_name.dart';

// SỬA LỖI: Hợp nhất logic từ router.dart vào đây và sửa lỗi thiếu tham số
class AppRoute {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    // Thêm các callback cần thiết
    {required VoidCallback onLoginSuccess, 
     required VoidCallback onLogout}
  ) {
    switch (settings.name) {
      case RouteName.home:
        // Cung cấp callback cho HomeScreen
        return MaterialPageRoute(builder: (_) => HomeScreen(onLogout: onLogout));
      case RouteName.login:
        // Cung cấp callback cho LoginScreen
        return MaterialPageRoute(builder: (_) => LoginScreen(onLoginSuccess: onLoginSuccess));
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteName.createPost:
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());
      case RouteName.resetPassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email));
      case RouteName.tutorialDetail:
        final tutorialSummary = settings.arguments as TutorialSummary;
        return MaterialPageRoute(builder: (_) => TutorialDetailScreen(tutorialSummary: tutorialSummary));
      case RouteName.lessonDetail:
        // Giờ đây `as LessonSummary` sẽ tham chiếu đến đúng lớp được import
        final lessonSummary = settings.arguments as LessonSummary;
        return MaterialPageRoute(builder: (_) => LessonDetailScreen(lessonSummary: lessonSummary));
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
    }
  }
}
