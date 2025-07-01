import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_routes.dart';
import '../../gen/colors.gen.dart';
import '../controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _startSplashLogic();
  }

  void _startSplashLogic() async {
    try {
      // Tampilkan CircularProgressIndicator minimal selama 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // Jalankan pengecekan autentikasi
      await _authController.initialAuthCheck();

      _navigateToNextScreen();
    } catch (e) {
      // Tangani jika pengecekan gagal
      print('Error during initial auth check: $e');
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (_authController.firebaseUser != null) {
      final role = _authController.currentUser?.role ?? '';
      Get.offNamed(_getRouteForRole(role));
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  String _getRouteForRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return AppRoutes.student;
      case 'driver':
        return AppRoutes.driver;
      case 'parent':
        return AppRoutes.parent;
      default:
        return AppRoutes.login;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.colorWhite,
      body: Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
