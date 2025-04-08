import 'package:flutter/material.dart';
import 'package:flutter_scan/app_router.dart';
import 'package:flutter_scan/themes/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

// สร้างตัวแปรสำหรับไว้เก็บหน้าหลักของแอปพลิเคชัน
dynamic initRoutes;

void main() async {

  // ต้องเรียกใช้ WidgetsFlutterBinding.ensureInitialized()
  // เพื่อให้ Flutter สามารถทำงานร่วมกับแพ็กเกจที่ต้องการการเริ่มต้นก่อน เช่น SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // อ่านค่า SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // ตรวจสอบว่าเคยผ่านหน้า login หรือยัง โดยการอ่านค่า loginStatus
  if (prefs.getBool('loginStatus') == null) {
    // ถ้ายังไม่เคยผ่านหน้า login ให้ไปที่หน้า login
    initRoutes = AppRouter.login;
  } else {
    // ถ้าเคยผ่านหน้า login ให้ไปที่หน้า dashboard
    initRoutes = AppRouter.dashboard;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: initRoutes,
      routes: AppRouter.routes,
    );
  }
}