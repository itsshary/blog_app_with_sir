import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blogapp_with_sir/SplashScreen/splashclass.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashscreen = SplashServices();

  void initState() {
    super.initState();
    splashscreen.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'BLOG APP',
              textStyle: const TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 4,
          pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }
}
