import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/l10n/app_localizations.dart';
import 'package:devlearn/routes/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiClient = ApiClient(dio: Dio(), secureStorage: const FlutterSecureStorage());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<User?> _userFuture;
  final _authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _userFuture = _authRepo.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevLearn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), 
        Locale('vi', ''), 
      ],
      home: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
      onGenerateRoute: onGenerateRoute,
      initialRoute: '/',
    );
  }
}
