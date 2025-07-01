import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:si_angkot/data/models/driver_history/driver_student_activity_model.dart';
import 'package:si_angkot/data/models/student_history/student_history_activity_detail.dart';

import '../models/driver_history/driver_history_model.dart';

class HistoryService {
  final databaseRef = FirebaseDatabase.instance.ref();

  /// Fetch history khusus untuk siswa
  Future<Map<String, List<StudentHistoryActivityDetail>>> fetchStudentHistory(
      String studentId) async {
    final Map<String, List<StudentHistoryActivityDetail>> groupedActivities =
        {};

    try {
      final snapshot = await databaseRef.child("History").once();
      final data = snapshot.snapshot.value;

      if (data != null && data is Map) {
        for (final dateEntry in data.entries) {
          final dateKey = dateEntry.key;
          final studentMap = Map<String, dynamic>.from(dateEntry.value);
          print("Student Data: Date Key: $dateKey");

          for (final studentEntry in studentMap.entries) {
            print("Student Data: Student Entry Key: ${studentEntry.key}");
            final dutyTypes = Map<String, dynamic>.from(studentEntry.value);

            for (final dutyType in ['Berangkat', 'Pulang']) {
              if (dutyTypes.containsKey(dutyType)) {
                print("Student Data:   Found dutyType: $dutyType");
                final dutyData = Map<String, dynamic>.from(dutyTypes[dutyType]);
                print("Student Data:   Found dutyData: $dutyData");

                final students = dutyData['students'] as Map?;
                if (students != null && students.containsKey(studentId)) {
                  print("Student Data:     Found studentId: $studentId");

                  final studentData =
                      Map<String, dynamic>.from(students[studentId]);
                  final onBoardTs = studentData['onBoardTimestamp'];
                  final offBoardTs = studentData['offBoardTimestamp'];

                  final dateStr = DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(dateKey),
                  );

                  print(
                      "Student Data:       onBoard: $onBoardTs, offBoard: $offBoardTs");

                  groupedActivities.putIfAbsent(dateStr, () => []);

                  void addActivity(String label, String tsString) {
                    try {
                      final timeParts = tsString.split(":");
                      final tsDateTime = DateTime(
                        int.parse(dateStr.split("-")[0]),
                        int.parse(dateStr.split("-")[1]),
                        int.parse(dateStr.split("-")[2]),
                        int.parse(timeParts[0]),
                        int.parse(timeParts[1]),
                        int.parse(timeParts[2]),
                      );
                      final tsMillis = tsDateTime.millisecondsSinceEpoch;

                      groupedActivities[dateStr]!.add(
                        StudentHistoryActivityDetail(
                          type: label,
                          time: DateFormat('HH:mm a').format(tsDateTime),
                          timestamp: tsMillis,
                        ),
                      );
                    } catch (e) {
                      print("Error parsing timestamp string: $e");
                    }
                  }

                  if (onBoardTs != null && onBoardTs is String) {
                    addActivity("$dutyType - Naik", onBoardTs);
                  }
                  if (offBoardTs != null && offBoardTs is String) {
                    addActivity("$dutyType - Turun", offBoardTs);
                  }
                }
              }
            }
          }
        }

        groupedActivities.forEach((_, activities) {
          activities.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });

        print("Grouped activities: $groupedActivities");
      }
    } catch (e) {
      print("Error fetching student history: $e");
    }

    return groupedActivities;
  }

  /// Fetch history untuk driver
  // Future<Map<String, Map<String, List<DriverStudentActivityModel>>>>
  //     fetchDriverHistory(String driverId) async {
  //   final groupedActivities =
  //       <String, Map<String, List<DriverStudentActivityModel>>>{};
  //   final userNames = <String, String>{};

  //   try {
  //     // Ambil semua nama user
  //     final userSnap = await databaseRef.child("User").once();
  //     final userMap = userSnap.snapshot.value;
  //     if (userMap != null && userMap is Map) {
  //       userMap.forEach((key, value) {
  //         if (value is Map && value['name'] != null) {
  //           userNames[key.toString()] = value['name'].toString();
  //         }
  //       });
  //     }

  //     final snapshot = await databaseRef
  //         .child("History")
  //         .orderByChild("driverId")
  //         .equalTo(driverId)
  //         .once();

  //     final data = snapshot.snapshot.value;
  //     if (data != null && data is Map) {
  //       data.forEach((key, rawValue) {
  //         final entry = Map<String, dynamic>.from(rawValue);

  //         final studentId = entry['studentId']?.toString();
  //         final dutyType = entry['dutyType']?.toString();
  //         final timestamp =
  //             entry['onBoardTimestamp'] ?? entry['offBoardTimestamp'];

  //         if (studentId != null &&
  //             dutyType != null &&
  //             timestamp != null &&
  //             (dutyType == 'berangkat' || dutyType == 'pulang')) {
  //           final dateStr = DateFormat('yyyy-MM-dd')
  //               .format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  //           final studentName = userNames[studentId] ?? 'Unknown Student';
  //           final formattedTime = DateFormat('HH:mm a')
  //               .format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  //           groupedActivities.putIfAbsent(
  //               dateStr,
  //               () => {
  //                     'berangkat': [],
  //                     'pulang': [],
  //                   });

  //           groupedActivities[dateStr]![dutyType]!.add(
  //             DriverStudentActivityModel(
  //               studentName: studentName,
  //               dutyType: dutyType,
  //               timestamp: timestamp,
  //               formattedTime: formattedTime,
  //             ),
  //           );
  //         }
  //       });

  //       groupedActivities.forEach((_, map) {
  //         map.forEach((_, list) {
  //           list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  //         });
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching driver history: $e");
  //   }

  //   return groupedActivities;
  // }

  Future<List<DriverHistoryModel>> fetchDriverHistoryList(
      String driverId) async {
    final historyList = <DriverHistoryModel>[];

    try {
      print("🔍 Fetching history for driverId: $driverId");

      final futures = await Future.wait([
        databaseRef.child("User").once(),
        databaseRef.child("History").once(),
      ]);

      final userSnap = futures[0];
      final historySnap = futures[1];

      // Cache user names
      final userNames = <String, String>{};
      final userMap = userSnap.snapshot.value;

      if (userMap is Map) {
        for (final entry in userMap.entries) {
          final value = entry.value;
          if (value is Map && value['name'] != null) {
            userNames[entry.key.toString()] = value['name'].toString();
          }
        }
        print("👤 Cached ${userNames.length} user names");
      }

      final historyMap = historySnap.snapshot.value;

      if (historyMap is Map) {
        print("📅 Found ${historyMap.length} date entries");

        for (final dateEntry in historyMap.entries) {
          final dateKey =
              dateEntry.key.toString(); // Format: YYYYMMDD (20250522)
          final dateValue = dateEntry.value;

          print("📅 Processing date: $dateKey");

          if (dateValue is Map && dateValue.containsKey(driverId)) {
            print("✅ Found driver $driverId on $dateKey");

            final driverData = dateValue[driverId];
            if (driverData is Map) {
              final allActivities = <DriverStudentActivityModel>[];

              for (final dutyTypeEntry in driverData.entries) {
                final dutyType =
                    dutyTypeEntry.key.toString(); // "Berangkat" or "Pulang"
                final dutyData = dutyTypeEntry.value;

                print("🎯 Processing duty type: $dutyType");

                if (dutyData is Map && dutyData.containsKey('students')) {
                  final studentsMap = dutyData['students'];

                  if (studentsMap is Map) {
                    print(
                        "👨‍🎓 Found ${studentsMap.length} students for $dutyType");

                    for (final studentEntry in studentsMap.entries) {
                      final studentId = studentEntry.key.toString();
                      final studentData = studentEntry.value;

                      if (studentData is Map) {
                        // Handle timestamp based on duty type
                        final timestampStr =
                            dutyType.toLowerCase() == 'berangkat'
                                ? studentData['onBoardTimestamp']
                                : studentData['offBoardTimestamp'];

                        print(
                            "⏰ Processing student $studentId with timestamp: $timestampStr");

                        if (timestampStr != null) {
                          final timestamp = _parseTimeToMillisWithDate(
                              dateKey, timestampStr.toString());

                          if (timestamp != null) {
                            final formattedTime = DateFormat('HH:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(timestamp));
                            final studentName =
                                userNames[studentId] ?? 'Unknown Student';

                            allActivities.add(
                              DriverStudentActivityModel(
                                studentName: studentName,
                                dutyType: dutyType.toLowerCase(),
                                timestamp: timestamp,
                                formattedTime: formattedTime,
                              ),
                            );

                            print(
                                "✅ Added activity: $studentName - $dutyType at $formattedTime");
                          }
                        }
                      }
                    }
                  }
                }
              }

              if (allActivities.isNotEmpty) {
                allActivities
                    .sort((a, b) => a.timestamp.compareTo(b.timestamp));

                historyList.add(
                  DriverHistoryModel(
                    id: dateKey,
                    date: _formatDateForDisplayFromYYYYMMDD(
                        dateKey), // Updated method
                    studentActivities: allActivities,
                  ),
                );

                print(
                    "✅ Added history for $dateKey with ${allActivities.length} activities");
              }
            }
          }
        }

        // Sort berdasarkan tanggal terbaru (descending)
        historyList.sort((a, b) => b.id.compareTo(a.id));
        print("🎉 Final history list size: ${historyList.length}");
      } else {
        print("❌ History data is null or not a Map");
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching driver history: $e");
      print("📋 Stack trace: $stackTrace");
    }

    return historyList;
  }

  // Fetch detail history untuk tanggal tertentu
  Future<Map<String, List<DriverStudentActivityModel>>>
      fetchDriverHistoryDetail(String driverId, String dateKey) async {
    final groupedActivities = <String, List<DriverStudentActivityModel>>{
      'berangkat': [],
      'pulang': [],
    };

    try {
      print("🔍 Fetching detail for driverId: $driverId, date: $dateKey");

      final futures = await Future.wait([
        databaseRef.child("Users").once(),
        databaseRef.child("History/$dateKey/$driverId").once(),
      ]);

      final userSnap = futures[0];
      final historySnap = futures[1];

      print("📊 History snapshot exists: ${historySnap.snapshot.exists}");

      // Cache user names
      final userNames = <String, String>{};
      final userMap = userSnap.snapshot.value;
      if (userMap is Map) {
        for (final entry in userMap.entries) {
          final value = entry.value;
          if (value is Map && value['name'] != null) {
            userNames[entry.key.toString()] = value['name'].toString();
          }
        }
        print("👤 Cached ${userNames.length} user names");
      }

      final driverData = historySnap.snapshot.value;
      if (driverData is Map) {
        print("📋 Driver data keys: ${driverData.keys.toList()}");

        for (final dutyTypeEntry in driverData.entries) {
          final dutyType = dutyTypeEntry.key
              .toString(); // Keep original case: "Berangkat" or "Pulang"
          final dutyTypeLower =
              dutyType.toLowerCase(); // For comparison and grouping
          final studentsNode = dutyTypeEntry.value;

          print(
              "🎯 Processing duty type: $dutyType (normalized: $dutyTypeLower)");

          if (studentsNode is Map && studentsNode.containsKey('students')) {
            final studentsMap = studentsNode['students'];

            if (studentsMap is Map) {
              print("👨‍🎓 Found ${studentsMap.length} students for $dutyType");

              for (final studentEntry in studentsMap.entries) {
                final studentId = studentEntry.key.toString();
                final studentData = studentEntry.value;

                if (studentData is Map) {
                  print("🔍 Processing student: $studentId");
                  print("📊 Student data keys: ${studentData.keys.toList()}");

                  // Handle timestamp based on duty type
                  final timestampStr = dutyTypeLower == 'berangkat'
                      ? studentData['onBoardTimestamp']
                      : studentData['offBoardTimestamp'];

                  print("⏰ Timestamp for $dutyTypeLower: $timestampStr");

                  if (timestampStr != null) {
                    final timestamp = _parseTimeToMillisWithDate(
                        dateKey, timestampStr.toString());

                    if (timestamp != null) {
                      final formattedTime = DateFormat('HH:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(timestamp));
                      final studentName =
                          userNames[studentId] ?? 'Unknown Student';

                      // Use normalized duty type for grouping
                      final targetGroup =
                          dutyTypeLower == 'berangkat' ? 'berangkat' : 'pulang';

                      groupedActivities[targetGroup]!.add(
                        DriverStudentActivityModel(
                          studentName: studentName,
                          dutyType: dutyTypeLower,
                          timestamp: timestamp,
                          formattedTime: formattedTime,
                        ),
                      );

                      print(
                          "✅ Added to $targetGroup: $studentName at $formattedTime");
                    } else {
                      print("❌ Failed to parse timestamp: $timestampStr");
                    }
                  } else {
                    print("⚠️ No timestamp found for $dutyTypeLower");
                  }
                } else {
                  print("⚠️ Student data is not a Map for: $studentId");
                }
              }
            } else {
              print("⚠️ Students map is not a Map for duty type: $dutyType");
            }
          } else {
            print("⚠️ No 'students' key found in duty type: $dutyType");
            print(
                "📋 Available keys: ${studentsNode is Map ? studentsNode.keys.toList() : 'N/A'}");
          }
        }

        // Sort each list by timestamp
        groupedActivities.forEach((key, list) {
          list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          print("📊 $key activities: ${list.length}");
        });

        print("🎉 Total berangkat: ${groupedActivities['berangkat']!.length}");
        print("🎉 Total pulang: ${groupedActivities['pulang']!.length}");
      } else {
        print("❌ Driver data is null or not a Map");
        print("📊 Driver data type: ${driverData.runtimeType}");
        print("📊 Driver data value: $driverData");
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching driver history detail: $e");
      print("📋 Stack trace: $stackTrace");
    }

    return groupedActivities;
  }

  int? _parseTimeToMillisWithDate(String dateKey, String timeStr) {
    try {
      // dateKey format: YYYYMMDD (e.g., "20250522")
      // timeStr format: "HH:mm:ss" (e.g., "14:50:47")

      if (dateKey.length != 8) {
        print("❌ Invalid date format: $dateKey");
        return null;
      }

      final year = int.parse(dateKey.substring(0, 4));
      final month = int.parse(dateKey.substring(4, 6));
      final day = int.parse(dateKey.substring(6, 8));

      // Parse time
      final timeParts = timeStr.split(':');
      if (timeParts.length < 2) {
        print("❌ Invalid time format: $timeStr");
        return null;
      }

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

      final dateTime = DateTime(year, month, day, hour, minute, second);
      return dateTime.millisecondsSinceEpoch;
    } catch (e) {
      print("❌ Error parsing date/time: $e");
      return null;
    }
  }

// Updated method to format date from YYYYMMDD
  String _formatDateForDisplayFromYYYYMMDD(String dateKey) {
    try {
      if (dateKey.length != 8) return dateKey;

      final year = int.parse(dateKey.substring(0, 4));
      final month = int.parse(dateKey.substring(4, 6));
      final day = int.parse(dateKey.substring(6, 8));

      final date = DateTime(year, month, day);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
          .format(date); // e.g., "Friday, 22 May 2025"
    } catch (e) {
      print("❌ Error formatting date: $e");
      return dateKey;
    }
  }
}
