import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:si_angkot/core.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
// import 'package:si_angkot/presentation/controller/driver_controller.dart';
// import 'package:si_angkot/presentation/controller/parent_controller.dart';
// import 'package:si_angkot/presentation/controller/student_controller.dart';

import 'data/local/shared_prefference_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await SharedPreferencesHelper.init();
  await Firebase.initializeApp();
  // initController();
  runApp(MainApp());
}

// void initController() {
//   Get.put(ParentController());
//   Get.put(StudentController());
//   Get.put(DriverController());
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        // Get.put(StudentController());
        // Get.put(ParentController());
        // Get.put(DriverController());
      }),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
