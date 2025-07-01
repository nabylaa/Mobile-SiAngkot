import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';

class InputNisnView extends GetView<DriverController> {
  final DriverController driverController = Get.find<DriverController>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nisnController = TextEditingController();

  InputNisnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF15A29), Color(0xFFFFC371)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Masukan Nomor NISN Penumpang",
                  style: AppTextStyle.textHeadingPoppins.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NISN Siswa",
                            style: AppTextStyle.textHeadingPoppins.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextField(
                            controller: nisnController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Contoh: 123456789",
                              hintStyle: AppTextStyle.textBASEPoppins.copyWith(
                                color: MyColors.fontColorHint,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        final nisn = nisnController.text.trim();
                        if (nisn.isNotEmpty) {
                          // Submit action here
                          // print("Submitted NISN: $nisn");
                          driverController.findNISN(
                            nisn,
                            authController.currentUser?.userId ?? "",
                          );
                          nisnController.clear();
                        }
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE16616), // warna centang di gambar
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // Back Button
        Positioned(
          top: 50,
          left: 20,
          child: InkWell(
            onTap: () {
              Get.back(); // Kembali ke halaman sebelumnya
            },
            child: MyAssets.svg.arrowLeft.svg(
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Title Centered
        const Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              "Input NISN",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
