import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/post/create_post_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'route_name.dart';

class AppRoute {
    static Map<String, WidgetBuilder> routes = {
        RouteName.home: (context) => const HomeScreen(),
        RouteName.login: (context) => const LoginScreen(),
        RouteName.register: (context) => const RegisterScreen(),
        RouteName.forgot: (context) => const ForgotPasswordScreen(),
        RouteName.createPost: (context) => const CreatePostScreen(),
        RouteName.splash: (context) => const SplashScreen(),
    };
}
