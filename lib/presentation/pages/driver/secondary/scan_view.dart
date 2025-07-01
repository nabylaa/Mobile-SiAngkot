import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:si_angkot/core.dart';

class ScanView extends GetView<DriverController> {
  ScanView({super.key});
  final DriverController driverController = Get.put(DriverController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    QRViewController? controller;

    void _onQRViewCreated(QRViewController qrController) {
      controller = qrController;
      qrController.scannedDataStream.listen((scanData) async {
        controller?.pauseCamera();
        if (scanData.code == null || scanData.code!.isEmpty) {
          AppUtils.showSnackbar("Gagal", "QR tidak valid", isError: true);
          controller?.resumeCamera();
          return;
        }
        await driverController.updateTrackingIdStudent(
          scanData.code.toString(),
          authController.currentUser?.userId ?? "",
        );
        await Future.delayed(Duration(seconds: 3));
        controller?.resumeCamera();
        // Lanjutkan ke screen lain atau proses hasil di sini
        // Get.to(ResultScreen(qr: scanData.code));
      });
    }

    return Stack(
      children: [
        QRView(
          key: qrKey,
          cameraFacing: CameraFacing.front,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderRadius: 16,
            borderLength: 30,
            borderWidth: 5,
            cutOutSize: 250,
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: InkWell(
            onTap: () {
              controller?.pauseCamera();
              Get.back();
            },
            child: MyAssets.svg.arrowLeft.svg(
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 0,
          left: 0,
          child: Center(
            child: Text(
              "Scan QR",
              style: AppTextStyle.textBASEPoppins
                  .copyWith(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
