import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // สร้างตัวแปร formKey เพื่อใช้ในการ validate form
  final GlobalKey<FormState> _formKey = GlobalKey();

  // สร้างตัวแปรเพื่อเก็บค่า email และ password
  String? _email, _password;

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
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'กรุณากรอกอีเมล';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
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
                      onPressed: () {
                        // ถ้าข้อมูลในฟอร์มถูกต้อง จะทำการบันทึกข้อมูล
                        if (_formKey.currentState!.validate()) {
                          // ถ้าข้อมูลถูกต้อง จะทำการบันทึกข้อมูล
                          _formKey.currentState!.save();

                          // แสดงข้อมูลที่กรอกในฟอร์ม
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Email: $_email, Password: $_password'),
                            ),
                          );

                          // ส่งไปหน้า Scan
                          Navigator.pushReplacementNamed(context, 'scan');
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