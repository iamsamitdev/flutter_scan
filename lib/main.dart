import 'package:flutter/material.dart';
import 'package:flutter_scan/app_router.dart';
import 'package:flutter_scan/themes/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login,
      routes: AppRouter.routes,
    );
  }
}