//fim
import 'package:flutter/material.dart';
import 'package:flutter_scan/bottompage/home_screen.dart';
import 'package:flutter_scan/bottompage/job_screen.dart';
import 'package:flutter_scan/bottompage/profile_screen.dart';
import 'package:flutter_scan/bottompage/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// statefulW
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // สร้างตัวแปรไว้เก็บ ชื่อ นามสกุล และอีเมลของผู้ใช้
  String? _firstName, _lastName, _userEmail;

  // เรียกใช้ initState() เพื่อทำการตั้งค่าเริ่มต้น
  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันอ่านข้อมูลจาก SharedPreferences
    _getUserInfo();
  }

  // อ่านข้อมูลจาก SharedPreferences
  Future<void> _getUserInfo() async {
    // สร้างตัวแปรสำหรับ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // อ่านค่าชื่อและอีเมลจาก SharedPreferences
    setState(() {
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
      _userEmail = prefs.getString('email') ?? '';
    });
  }

  // สร้างฟังก์ชันสำหรับ logout
  Future<void> _logout() async {
    // สร้างตัวแปรสำหรับ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // ลบข้อมูลการเข้าสู่ระบบ
    await prefs.remove('loginStatus');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('email');
    
    // นำทางไปยังหน้า login
    Navigator.pushReplacementNamed(context, 'login');
  }

  // สร้างตัวแปรไว้เก็บ title ของแต่ละ screen
  String _title = 'Flutter Scan';

  // สร้างตัวแปรไว้เก็บ index ของ bottom navigation bar
  int _currentIndex = 0;

  // สร้าง List ของแต่ละหน้า
  final List<Widget> _screens = [
    HomeScreen(),
    JobScreen(),
    Container(),     // index 2 สำหรับปุ่ม Scan (ไม่ใช้งานจริง)
    SettingScreen(),
    ProfileScreen()
  ];

  // สร้างฟังก์ชันสำหรับเปลี่ยนหน้า
  void onTabTapped(int index) {
    if (index == 2) {
      // ถ้ากดที่ปุ่มกลางให้ไปที่หน้า Scan โดยไม่เปลี่ยน _currentIndex
      Navigator.pushNamed(context, 'scan');
      return;
    }
    if (index < _screens.length) {
      setState(() {
        _currentIndex = index;
        switch (index) {
          case 0: _title = 'Home'; break;
          case 1: _title = 'Jobs'; break;
          case 3: _title = 'Setting'; break;
          case 4: _title = 'Profile'; break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // fscaff
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('$_firstName $_lastName'),
                  accountEmail: Text('$_userEmail'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '$_firstName'.substring(0, 1).toUpperCase() + '$_lastName'.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 40.0, color: Colors.black),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Info'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Contact'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    // เรียกใช้ฟังก์ชัน logout
                    _logout();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(153, 33, 150, 243),
                    spreadRadius: 3,
                    blurRadius: 20,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 30,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}