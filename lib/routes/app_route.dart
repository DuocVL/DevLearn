import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/post/create_post_screen.dart';
import '../features/splash/splash_screen.dart';
import 'route_name.dart';

class AppRoute {
    static Map<String, WidgetBuilder> routes = {
        RouteName.home: (context) => const HomeScreen(),
        RouteName.login: (context) => const LoginScreen(),
        RouteName.register: (context) => const RegisterScreen(),
        RouteName.forgotPassword: (context) => const ForgotPasswordScreen(),
        RouteName.createPost: (context) => const CreatePostScreen(),
        RouteName.splash: (context) => const SplashScreen(),
    };
}
