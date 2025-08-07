import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teacher/backend/class/class_provider.dart';
import 'package:teacher/backend/student/student_provider.dart';
import 'package:teacher/backend/teacher/teacher_provider.dart';
import 'package:teacher/splash.dart';

import 'firebase_options.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StudentProvider()),
      ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ChangeNotifierProvider(create: (_) => ClassProvider()),
    ],
    child: MyApp()
     ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
