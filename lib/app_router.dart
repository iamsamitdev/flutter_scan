import 'package:flutter_scan/dashboard.dart';
import 'package:flutter_scan/features/auth/login_screen.dart';
import 'package:flutter_scan/features/scanner/scan_screen.dart';

class AppRouter {

  static const String login = 'login';
  static const String scan = 'scan';
  static const String dashboard = 'dashboard';

  static get routes => {
    login: (context) => const LoginScreen(),
    scan: (context) => const ScanScreen(),
    dashboard: (context) => const DashboardScreen()
  };
}