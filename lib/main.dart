import 'package:devlearn/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env from the project root (the Flutter working directory).
  await dotenv.load(fileName: '.env');
  runApp(const DevLearnApp());
}