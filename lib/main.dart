import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'splash_screen.dart';
import 'home_screen.dart';

class MyAppRoutes {
  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    errorPageBuilder: (BuildContext context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    ),
    routes: [
      // Define your routes here
      GoRoute(
        path: '/',
        builder: (context, state) =>
            SplashScreen(), // Define your default route
      ),
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, state) {
          return SplashScreen();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, state) {
          return HomeScreen();
        },
      ),
    ],
  );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MyAppRoutes()._router,
    );
  }
}
