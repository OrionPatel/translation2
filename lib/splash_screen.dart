import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),
        () => pushReplacement(context)); // Adjust delay as needed
  }

  void pushReplacement(BuildContext context) {
    context.go('/home',
        extra: 'Data from splash screen'); // Pass data if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            Image.asset('assets/splashscreen.jpg'), // Load splash screen image
      ),
    );
  }
}
