import 'package:flutter/material.dart';
import 'package:flutter_scan/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันเช็คสถานะการเข้าสู่ระบบเมื่อเริ่มต้น
    _checkLoginStatus();
  }

  // สร้างฟังก์ชันเช็คสถานะการเข้าสู่ระบบ
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('loginStatus') ?? false;

    if (isLoggedIn) {
      // ถ้าเคย login แล้ว → ไปหน้า dashboard เลย
      Navigator.pushReplacementNamed(context, 'dashboard');
    }
  }

  // สร้างตัวแปร formKey เพื่อใช้ในการ validate form
  final GlobalKey<FormState> _formKey = GlobalKey();

  // สร้างตัวแปรเพื่อเก็บค่า email และ password
  String? _username, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'เข้าสู่ระบบ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: 'emilys',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'กรุณากรอกชื่อผู้ใช้';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: 'emilyspass',
                      validator: (value){
                        if(value!.isEmpty){
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // ถ้าข้อมูลในฟอร์มถูกต้อง จะทำการบันทึกข้อมูล
                        if (_formKey.currentState!.validate()) {
                          // ถ้าข้อมูลถูกต้อง จะทำการบันทึกข้อมูล
                          _formKey.currentState!.save();

                          print('Username: $_username, Password: $_password');

                          try {

                            final response = await ApiService().login(_username!, _password!);

                            // ตรวจสอบว่าการเข้าสู่ระบบสำเร็จหรือไม่
                             if (response['error'] == null) {

                              // เข้าสู่ระบบสำเร็จ
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('loginStatus', true);
                              await prefs.setString('firstName', response['firstName']);
                              await prefs.setString('lastName', response['lastName']);
                              await prefs.setString('email', response['email']);
                              
                              Navigator.pushReplacementNamed(context, 'dashboard');
                            } else {
                              // เข้าสู่ระบบไม่สำเร็จ
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('ข้อมูลเข้าสู่ระบบไม่ถูกต้อง ลองใหม่อีกครั้ง'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }

                          } catch (e) {
                            // ดักจับข้อผิดพลาดจากการเชื่อมต่อหรืออื่นๆ
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('เกิดข้อผิดพลาด: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}