import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal, // ความเร็วในการตรวจจับ
    torchEnabled: false, // เปิดไฟฉายหรือไม่
    facing: CameraFacing.back, // กล้องที่ใช้ (กล้องหน้า/หลัง)
  );

  final List<String> scannedResults = [];

  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Screen'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // กว้าง 90% ของจอ
            height: MediaQuery.of(context).size.height * 0.4, // ครึ่งจอบน
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), // ปรับความโค้งมนตามต้องการ
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        if (_isScanning) return;
                        final barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          setState(() {
                            _isScanning = true;
                            final code = barcodes.first.rawValue ?? 'ไม่พบข้อมูล';
                            if (!scannedResults.contains(code)) {
                              scannedResults.add(code);
                            }
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isScanning = false;
                            });
                          });
                        }
                      },
                    ),
                  ),
                ),
                // เส้นเลเซอร์
                Center(
                  child: CustomPaint(
                    painter: LaserPainter(),
                    size: const Size(double.infinity, 2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: scannedResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text(scannedResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// วาดเส้นเลเซอร์สีแดงตรงกลาง
class LaserPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 2;
    final centerY = size.height / 2;
    canvas.drawLine(Offset(size.width * 0.05, centerY), Offset(size.width * 0.95, centerY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
