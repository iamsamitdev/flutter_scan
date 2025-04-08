import 'package:dio/dio.dart';

class ApiService {

  // สร้าง instance ของ Dio
  final Dio _dio = Dio();

  // สร้างฟังก์ชันสำหรับการ Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://dummyjson.com/auth/login', // URL ของ API
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30, // ระยะเวลาที่ Token จะหมดอายุ
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json', // กำหนด Content-Type เป็น JSON
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // คืนค่าข้อมูลที่ได้รับจาก API
      } else {
        return {
          "error": "Login failed",
          "message": response.statusMessage ?? "เข้าสู่ระบบไม่สำเร็จ กรุณาลองใหม่",
        }; // คืนค่าข้อความผิดพลาดถ้า status code ไม่ใช่ 200
      }

    } catch (e) {
      // ถ้ามีข้อผิดพลาดให้แสดงข้อความ
      print("Error: $e");
      return {
        'error': true,
        'message': 'ไม่สามารถเชื่อมต่อกับระบบได้',
      };
    }
  }

}