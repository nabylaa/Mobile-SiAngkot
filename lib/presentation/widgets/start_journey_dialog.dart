import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:si_angkot/presentation/controller/auth_controller.dart';
import 'package:si_angkot/presentation/controller/driver_controller.dart';

class StartJourneyDialog extends StatelessWidget {
  StartJourneyDialog({super.key});
  final DriverController driverController = Get.put(DriverController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status & Rute Perjalanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Custom Status Dropdown
            Obx(() => Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      _showStatusPicker(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            driverController.deliveryType.value.isEmpty
                                ? 'Pilih Status'
                                : driverController.deliveryType.value,
                            style: TextStyle(
                              color: driverController.deliveryType.value.isEmpty
                                  ? Colors.grey.shade400
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            const Text(
              'Rute',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Custom Route Dropdown
            Obx(() => Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      _showRoutePicker(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            driverController.selectedRoute.value.isEmpty
                                ? 'Pilih Rute'
                                : driverController.selectedRoute.value,
                            style: TextStyle(
                              color:
                                  driverController.selectedRoute.value.isEmpty
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            // Save Button with gradient
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE37B24), Color(0xFFFFB765)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (driverController.selectedRoute.value.isEmpty) {
                    Get.snackbar("Error", "Pilih route terlebih dahulu");
                    return;
                  }
                  if (driverController.deliveryType.value.isEmpty) {
                    Get.snackbar(
                        "Error", "Pilih jenis pengantaran terlebih dahulu");
                    return;
                  }
                  driverController.dutyType.value = "OnDuty";
                  await driverController.saveTrackingAndFetchRouteDetail(
                    authController.currentUser?.userId ?? '',
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom picker for Status
  void _showStatusPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  final status = ['Berangkat', 'Pulang'][index];
                  return ListTile(
                    title: Text(status),
                    onTap: () {
                      driverController.deliveryType.value = status;
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Custom picker for Route
  void _showRoutePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Rute',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: driverController.routeNames.length,
                  itemBuilder: (context, index) {
                    final route = driverController.routeNames[index];
                    return ListTile(
                      title: Text(route),
                      onTap: () {
                        driverController.selectedRoute.value = route;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
