import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
// THÊM: Import TrackingRoute để có thể gọi route này
import 'package:my_tracker_app/src/modules/app/app_router.dart';

@RoutePage()
class MobileScannerPage extends StatefulWidget {
  const MobileScannerPage({super.key});

  @override
  State<MobileScannerPage> createState() => _MobileScannerPageState();
}

class _MobileScannerPageState extends State<MobileScannerPage> {
  late final MobileScannerController _scannerController;
  late bool _isFlashOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // HÀM MỚI: Xử lý chuyển hướng
  void _navigateToTrackingPage(String code) {
    // Dùng replace để đóng MobileScannerPage và chuyển sang TrackingRoute
    // Đồng thời truyền mã vận đơn vào tham số initialTrackingNumber
    context.router.replace(
      TrackingRoute(initialTrackingNumber: code),
    );
  }

  Future<void> scanFromGallery() async {
    _scannerController.stop();
    setState(() => _isProcessing = true);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final BarcodeCapture? capture =
            await _scannerController.analyzeImage(pickedFile.path);

        if (capture != null &&
            capture.barcodes.isNotEmpty &&
            capture.barcodes.first.rawValue != null) {
          final String code = capture.barcodes.first.rawValue!;
          if (mounted)
            _navigateToTrackingPage(code); // <-- GỌI HÀM CHUYỂN HƯỚNG
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No QR code found in the image.')),
            );
            _scannerController.start();
          }
        }
      } else {
        _scannerController.start();
      }
    } catch (e) {
      _scannerController.start();
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindowRect = Rect.fromCenter(
      center: Offset(180.w, 301.h),
      width: 300.r,
      height: 300.r,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorName.inkWell,
        elevation: 0,
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.images,
              color: ColorName.white,
              size: 24.r,
            ),
            onPressed: scanFromGallery,
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.bolt,
              color: _isFlashOn ? ColorName.yellow : ColorName.white,
            ),
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
            },
          ),
        ],
        iconTheme: const IconThemeData(color: ColorName.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _scannerController.stop();
                final String code = barcodes.first.rawValue!;
                _navigateToTrackingPage(code); // <-- GỌI HÀM CHUYỂN HƯỚNG
              }
            },
          ),
          CustomPaint(
            painter: ScannerOverlayPainter(scanWindow: scanWindowRect),
          ),
          Positioned.fromRect(
            rect: scanWindowRect,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorName.white.withValues(
                    alpha: 0.7,
                  ),
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// KHÔNG THAY ĐỔI
class ScannerOverlayPainter extends CustomPainter {
  const ScannerOverlayPainter({required this.scanWindow});

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final paint = Paint()..color = ColorName.black.withValues(alpha: 0.6);
    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow;
  }
}
