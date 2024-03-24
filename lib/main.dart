import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:survey_jys/firebase_options.dart';
import 'package:survey_jys/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color mainColor = const Color(0xffFD3C4F);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JYS승자예측',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
