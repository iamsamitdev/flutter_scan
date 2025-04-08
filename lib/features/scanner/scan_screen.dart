import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    torchEnabled: false,
    facing: CameraFacing.back,
  );

  final List<String> scannedResults = [];
  bool _isScanning = false;

  late AnimationController _laserController;
  late Animation<double> _laserOpacity;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _laserOpacity = Tween(begin: 0.0, end: 1.0).animate(_laserController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'สแกน QR หรือบาร์โค้ด',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // กล้อง
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_isScanning) return;
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                setState(() {
                  _isScanning = true;
                  final code = barcodes.first.rawValue ?? 'ไม่พบข้อมูล';

                  // ถ้าสแกนเจอแล้วให้แสดงผล
                  if (!scannedResults.contains(code)) {
                    scannedResults.add(code); // เพิ่มผลลัพธ์ที่สแกนลงในรายการ
                    // แสดงผลลัพธ์ที่สแกน
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('สแกนเจอ: $code'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    // ปิดการสแกน
                    Navigator.pop(context, code);
                  }

                });
              }
            },
          ),
          // กล่องโฟกัส
          Center(
            child: Container(
              width: 280,
              height: 280,
            ),
          ),
          // เส้นเลเซอร์แนวตั้งกระพริบ
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 180,
            left: MediaQuery.of(context).size.width / 2 - 1,
            child: AnimatedBuilder(
              animation: _laserOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _laserOpacity.value,
                  child: Container(
                    width: 2,
                    height: 280,
                    color: Colors.redAccent,
                  ),
                );
              },
            ),
          ),
          // ขอบมุม
          Positioned.fill(
            child: CustomPaint(
              painter: BorderCornerPainter(),
            ),
          ),
          // คำแนะนำ + ปุ่มล่าง
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: Colors.white),
                      onPressed: () {
                        _controller.toggleTorch();
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'กรุณาวาง QR หรือบาร์โค้ด\nให้อยู่ในพื้นที่ที่กำหนด',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.white),
                      onPressed: () {
                        // TODO: เพิ่มเลือกภาพจากแกลเลอรี
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// วาดขอบมุม 4 ด้าน
class BorderCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const length = 30.0;
    const rectSize = 280.0;
    final offsetX = (size.width - rectSize) / 2;
    final offsetY = (size.height - rectSize) / 2;

    final corners = [
      // top-left
      [
        Offset(offsetX, offsetY + length),
        Offset(offsetX, offsetY),
        Offset(offsetX + length, offsetY),
      ],
      // top-right
      [
        Offset(offsetX + rectSize - length, offsetY),
        Offset(offsetX + rectSize, offsetY),
        Offset(offsetX + rectSize, offsetY + length),
      ],
      // bottom-left
      [
        Offset(offsetX, offsetY + rectSize - length),
        Offset(offsetX, offsetY + rectSize),
        Offset(offsetX + length, offsetY + rectSize),
      ],
      // bottom-right
      [
        Offset(offsetX + rectSize - length, offsetY + rectSize),
        Offset(offsetX + rectSize, offsetY + rectSize),
        Offset(offsetX + rectSize, offsetY + rectSize - length),
      ],
    ];

    for (final pathPoints in corners) {
      final path = Path()..moveTo(pathPoints[0].dx, pathPoints[0].dy);
      for (final point in pathPoints.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
