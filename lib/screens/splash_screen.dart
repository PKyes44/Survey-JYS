import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/vote_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isToken = false;
  String? studentNumber = "";
  String? name = "";
  String? point = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    studentNumber = pref.getString('studentNumber');
    name = pref.getString('name');
    point = pref.getString('point');

    if (studentNumber != null && name != null && point != null) {
      isToken = true;
      setState(() {});
      print("Token Completed : $studentNumber - $name - $point");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/JYS-Survey_logo.png',
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
      splashIconSize: Sizes.size36 * 5,
      nextScreen: isToken
          ? MakeQuestionScreen(
              studentNumber: studentNumber,
              name: name,
              point: point,
            )
          : const LoginScreen(),
    );
  }
}
