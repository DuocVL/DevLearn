import 'package:flutter/material.dart';
import '../features/login/login_screen.dart';
import '../features/register/register_screen.dart';
import '../features/forgot_password/forgot_password_screen.dart';
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
