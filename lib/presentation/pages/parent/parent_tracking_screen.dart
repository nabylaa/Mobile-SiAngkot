import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:si_angkot/core.dart';
import 'package:si_angkot/presentation/controller/history_controller.dart';
import 'package:si_angkot/presentation/controller/parent_controller.dart';
import 'package:si_angkot/presentation/pages/parent/detail/tracking_history_screen.dart';
import 'package:si_angkot/presentation/pages/parent/detail/tracking_profile_screen.dart';
import 'package:si_angkot/presentation/pages/parent/detail/tracking_status_screen.dart';

class ParentTrackingScreen extends StatefulWidget {
  ParentTrackingScreen({super.key});

  @override
  State<ParentTrackingScreen> createState() => _ParentTrackingScreenState();
}

class _ParentTrackingScreenState extends State<ParentTrackingScreen> {
  final ParentController controller = Get.find<ParentController>();

  final HistoryController historyController = Get.put(HistoryController());

  final studentData = Get.arguments as UserModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyController.fetchStudentHistory(studentData.userId, true);
    historyController.selectStudentHistory(studentData);
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (controller.studentTrackingId.value.isEmpty) {
          Future.microtask(() {
            if (Get.isDialogOpen != true) {
              Get.dialog(
                AlertDialog(
                  title: const Text('Perjalanan Selesai'),
                  content: const Text(
                    'Perjalanan anak anda telah tiba di tujuan, anda akan kembali ke halaman utama.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(); // Tutup dialog
                        Get.back(); // Kembali ke halaman utama
                      },
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final lat = controller.latitude.value;
        final lng = controller.longitude.value;

        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 5)),
          builder: (context, snapshot) {
            if (lat == 0.0 && lng == 0.0) {
              if (snapshot.connectionState != ConnectionState.done) {
                // Menunggu 5 detik, tampilkan loading
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                    strokeWidth: 2.0,
                  ),
                );
              } else {
                // Setelah 5 detik, jika masih 0,0 tampilkan dialog timeout
                Future.microtask(() {
                  if (Get.isDialogOpen != true) {
                    AppUtils.showDialog("Timeout",
                        "Gagal mendapatkan lokasi. Silahkan coba lagi nanti",
                        onConfirm: () {
                      Get.back();
                      Get.back();
                    }, onCancel: () {
                      Get.back();
                      Get.back();
                    }, countdownSeconds: 5);
                  }
                });
                return const SizedBox.shrink();
              }
            }
            // Jika lat/lng sudah ada sebelum 5 detik, langsung tampilkan Stack
            return Stack(
              children: [
                // Full screen map as the background
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 300,
                  child: Obx(() => FlutterMap(
                        mapController: controller.mapController,
                        options: MapOptions(
                          center: LatLng(controller.latitude.value,
                              controller.longitude.value),
                          zoom: 17.0,
                          minZoom: 14.0,
                          maxZoom: 18.3,
                          interactiveFlags: InteractiveFlag.all,
                          keepAlive: true,
                          onMapReady: () {
                            print(
                                "MAP READY : ${controller.latitude.value}, ${controller.longitude.value}");
                            controller.mapController.move(
                              LatLng(controller.latitude.value,
                                  controller.longitude.value),
                              17.0,
                            );
                          },
                          onPositionChanged:
                              (MapPosition position, bool hasGesture) {
                            if (hasGesture) {
                              // Reset timer setiap ada interaksi
                              controller.recenterTimer?.cancel();
                              controller.recenterTimer =
                                  Timer(const Duration(seconds: 2), () {
                                controller.mapController.move(
                                  LatLng(controller.latitude.value,
                                      controller.longitude.value),
                                  17.0,
                                );
                              });
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40.0,
                                height: 40.0,
                                point: LatLng(controller.latitude.value,
                                    controller.longitude.value),
                                builder: (ctx) => Icon(
                                  Icons.local_taxi,
                                  color: MyColors.primaryColor,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),

                // Orange header at top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 40, left: 8, right: 16, bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.primaryColor,
                          MyColors.secondaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: MyAssets.svg.arrowLeft.svg(
                              width: 30,
                              height: 30,
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person,
                                  color: Colors.grey[400], size: 30),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            studentData.name,
                            style: AppTextStyle.textHeadingPoppins.copyWith(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom sheet with tab content
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tab bar
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Obx(() {
                            return Row(
                              children: [
                                _buildTab('Status', 0,
                                    controller.selectedTabIndex.value),
                                _buildTab('History', 1,
                                    controller.selectedTabIndex.value),
                                _buildTab('Profile', 2,
                                    controller.selectedTabIndex.value),
                              ],
                            );
                          }),
                        ),

                        // Tab content
                        Container(
                          height: 400, // Adjust height as needed
                          child: Obx(() {
                            return _buildSelectedTabContent(
                                controller.selectedTabIndex.value);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildTab(String title, int index, int selectedIndex) {
    final isSelected = index == selectedIndex;

    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? MyColors.primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isSelected ? MyColors.primaryColor : MyColors.fontColorHint,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TrackingStatusScreen();
      case 1:
        return TrackingHistoryScreen();
      case 2:
        return TrackingProfileScreen();
      default:
        return Container();
    }
  }
}
