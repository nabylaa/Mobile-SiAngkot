import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:si_angkot/core/app_routes.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/models/users_model.dart';
import 'package:si_angkot/data/remote/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxList<UserModel> _linkedStudents = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Stream untuk memantau status verifikasi student
  StreamSubscription? _studentVerificationSubscription;

  // Stream subscription untuk mendengarkan perubahan pada linkedStudents
  StreamSubscription? _linkedStudentsSubscription;

  User? get firebaseUser => _firebaseUser.value;
  UserModel? get currentUser => _currentUser.value;
  List<UserModel> get linkedStudents => _linkedStudents;
  bool get isParent => currentUser?.role == Constant.PARENT;
  bool get isStudent => currentUser?.role == Constant.STUDENT;

  @override
  void onInit() {
    // Bind the Firebase authentication state changes stream
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());

    // Use ever to react to changes in the Firebase user
    ever(_firebaseUser, _handleAuthChange);
    super.onInit();
  }

  @override
  void onClose() {
    // Membersihkan subscription ketika controller dihapus
    _linkedStudentsSubscription?.cancel();
    _studentVerificationSubscription?.cancel();
    super.onClose();
  }

  Future<void> initialAuthCheck() async {
    try {
      isLoading.value = true;

      // Ambil user saat ini dari Firebase
      final currentFirebaseUser = FirebaseAuth.instance.currentUser;

      // Update _firebaseUser secara manual
      _firebaseUser.value = currentFirebaseUser;

      if (currentFirebaseUser != null && currentUser == null) {
        // Jika ada user Firebase tetapi belum memuat profil
        await _loadUserProfile(currentFirebaseUser.uid);

        // Jika user adalah parent, mulai mendengarkan linkedStudents
        if (isParent) {
          _startLinkedStudentsListener();
        } else if (isStudent) {
          _startStudentVerificationListener();
// Handle navigasi berdasarkan status verifikasi
          _handleStudentVerification();
        }
      }
    } catch (e) {
      errorMessage.value = 'Initial auth check failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthChange(User? user) async {
    // Bersihkan subscription yang ada
    _linkedStudentsSubscription?.cancel();

    if (user == null) {
      // User is signed out
      _currentUser.value = null;
      _linkedStudents.clear();
      Get.offAllNamed(AppRoutes.login);
    } else {
      // User is signed in, load user profile
      await _loadUserProfile(user.uid);

      // Navigate based on user role
      if (isParent) {
        _startLinkedStudentsListener();
        Get.offAllNamed(AppRoutes.parent);
      } else if (isStudent) {
        _startStudentVerificationListener();
        _handleStudentVerification();
      } else {
        Get.offAllNamed(AppRoutes.driver);
      }
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      isLoading.value = true;
      final user = await _authService.getUserProfile(userId);
      _currentUser.value = user;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to load user profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLinkedStudents() async {
    try {
      isLoading.value = true;
      // Batalkan subscription yang ada
      _linkedStudentsSubscription?.cancel();

      // Memulai kembali listener untuk mendapatkan data terbaru
      _startLinkedStudentsListener();

      // Tambahkan delay kecil agar refresh indicator bisa terlihat
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      errorMessage.value = 'Failed to fetch linked students: ${e.toString()}';
      AppUtils.showSnackbar("Error", "Failed to refresh data", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Metode baru untuk memulai listener realtime
  void _startLinkedStudentsListener() {
    try {
      // Pastikan ada parent ID
      if (currentUser == null || currentUser!.userId.isEmpty) {
        errorMessage.value = 'Cannot start listener: User not found';
        print('TRACKER: Cannot start listener: User not found');
        return;
      }

      // Batalkan subscription sebelumnya jika ada
      _linkedStudentsSubscription?.cancel();

      // Dapatkan stream data dari AuthService
      final stream =
          _authService.getStudentsByParentStream(currentUser!.userId);

      // Subscribe ke stream
      _linkedStudentsSubscription = stream.listen((List<UserModel> students) {
        _linkedStudents.value = students;
      }, onError: (error) {
        errorMessage.value = 'Student listener error: ${error.toString()}';
      });

      print(
          'TRACKER: Started realtime listener for parent ${currentUser!.userId} linked students | count: ${_linkedStudents.length}');
    } catch (e) {
      errorMessage.value = 'Failed to start students listener: ${e.toString()}';
    }
  }

  void _handleStudentVerification() {
    if (isStudent) {
      if (currentUser?.isVerify == true) {
        // Student terverifikasi, navigasi ke dashboard
        Get.offAllNamed(AppRoutes.student);
      } else {
        // Student belum terverifikasi, navigasi ke halaman pending
        Get.offAllNamed(AppRoutes.studentPending);
      }
    }
  }

  // Memulai listener untuk status verifikasi student
  void _startStudentVerificationListener() {
    try {
      // Pastikan ada student ID
      if (currentUser == null || currentUser!.userId.isEmpty) {
        errorMessage.value =
            'Cannot start verification listener: User not found';
        print('TRACKER: Cannot start verification listener: User not found');
        return;
      }

      // Batalkan subscription sebelumnya jika ada
      _studentVerificationSubscription?.cancel();

      // Dapatkan stream data verifikasi student dari AuthService
      final stream =
          _authService.getStudentVerificationStream(currentUser!.userId);

      // Subscribe ke stream
      _studentVerificationSubscription = stream.listen((UserModel updatedUser) {
        // Update user model dengan data terbaru
        _currentUser.value = updatedUser;

        // Handle navigasi berdasarkan status verifikasi yang baru
        _handleStudentVerification();

        print(
            'TRACKER: Student verification status updated: ${updatedUser.isVerify}');
      }, onError: (error) {
        errorMessage.value = 'Verification listener error: ${error.toString()}';
      });

      print(
          'TRACKER: Started verification listener for student ${currentUser!.userId}');
    } catch (e) {
      errorMessage.value =
          'Failed to start verification listener: ${e.toString()}';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _authService.login(email, password);
      if (user == null) {
        throw Exception('User not found');
      } else {
        _currentUser.value = await _authService.getUserProfile(user.uid);
        if (isParent) {
          _startLinkedStudentsListener(); // Ganti dengan realtime listener
          Get.offAllNamed(AppRoutes.parent);
        } else if (isStudent) {
          if (currentUser?.isVerify == true) {
            // Student terverifikasi, mulai listener verifikasi dan navigasi
            _startStudentVerificationListener();
            Get.offAllNamed(AppRoutes.student);
          } else {
            // Student belum terverifikasi, jangan izinkan login penuh
            _startStudentVerificationListener();
            Get.offAllNamed(AppRoutes.studentPending);
            AppUtils.showSnackbar('Verification Required',
                'Your account is waiting for verification. Please wait for approval.',
                isError: true);
          }
        } else {
          Get.offAllNamed(AppRoutes.driver);
        }
        AppUtils.showSnackbar('Success', 'Login successful');
        print(
            "TRACKER : current user value ${_currentUser.value?.role} || $firebaseUser");
      }
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
      AppUtils.showSnackbar("Login Failed", errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      required String phone,
      required String address,
      required String role}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.register(email, password);
      print('TRACKER : after register user $user');
      if (user == null) {
        throw Exception('TRACKER :  Registration failed user null');
      }

      UserModel newUser = UserModel(
        userId: user.uid,
        name: name,
        email: email,
        phone: phone,
        address: address,
        role: role,
        picture: '',
      );
      print('TRACKER : user model created');

      // Create user profile in the database
      await _authService.createUserProfile(newUser);
      _currentUser.value = await _authService.getUserProfile(user.uid);
      print('TRACKER : after createUserProfile');
      AppUtils.showSnackbar('Success', 'Registration successful');
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> registerStudent({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required String nisn,
    required String school,
    required String schoolAddress,
    String picture = '',
  }) async {
    try {
      isLoading.value = true;
      final parentId = currentUser!.userId;
      final UserModel studentData = UserModel(
        userId: '',
        name: name,
        phone: phone,
        address: address,
        email: email,
        role: Constant.STUDENT,
        picture: picture,
        trackingId: '',
        isVerify: false,
        nisn: nisn,
        school: school,
        schoolAddress: schoolAddress,
      );
      final studentId = await _authService.registerAndAddStudent(
          parentId, email, password, studentData);
      if (studentId != null) {
        print('Student berhasil didaftarkan dengan ID: $studentId');
        // Parent tetap login!
        print(
            'Parent masih login dengan ID: ${FirebaseAuth.instance.currentUser!.uid}');
        // Tidak perlu _loadLinkedStudents() karena listener realtime akan memperbarui data
        return true;
      } else {
        print('Gagal mendaftarkan student');
        return false;
      }
    } catch (e) {
      print('Gagal mendaftarkan student ${e.toString()}');
      errorMessage.value = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Batalkan subscription sebelum logout
      _linkedStudentsSubscription?.cancel();
      _studentVerificationSubscription?.cancel();

      // Simpan referensi terlebih dahulu jika perlu melakukan operasi
      // final user = firebaseUser;

      // Lakukan logout
      await _authService.logout();
      _currentUser.value = null;

      // Jangan hapus akun pengguna, cukup logout
      // firebaseUser?.delete(); <- HAPUS BARIS INI

      Get.offAllNamed(AppRoutes.login);
      AppUtils.showSnackbar('Success', 'Logout successful');
    } catch (e) {
      errorMessage.value = 'Logout failed: ${e.toString()}';
      print('Logout error: $e'); // Tambahkan log untuk debugging
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.updateUserProfile(updatedUser).then((value) {
        _currentUser.value = updatedUser;
        Get.back();
        AppUtils.showSnackbar('Success', 'Profile updated successfully');
        print('TRACKER : update profile success ${_currentUser.value}');
      }).catchError((error) {
        print('TRACKER : update profile error $error');
        throw Exception('Update failed: ${error.toString()}');
      });
    } catch (e) {
      errorMessage.value = 'Update failed: ${e.toString()}';
      AppUtils.showSnackbar('Error', "Update data failed", isError: true);
      // rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStudent(String studentId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _authService.addStudentToParent(currentUser!.userId, studentId);
      // Tidak perlu memanggil _loadLinkedStudents() lagi karena listener realtime
      // akan menangkap perubahan secara otomatis
      Get.snackbar('Success', 'Student added successfully');
    } catch (e) {
      errorMessage.value = 'Failed to add student: ${e.toString()}';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> searchStudent(String nisn) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final student = await _authService.searchStudentByNISN(nisn);
      return student;
    } catch (e) {
      errorMessage.value = 'Search failed: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() => errorMessage.value = '';

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    // Validation
    if (email.isEmpty) {
      AppUtils.showSnackbar("Oops!", 'Please enter your email address',
          isError: true);
      isLoading.value = false;
      return;
    }

    if (!_isValidEmail(email)) {
      AppUtils.showSnackbar("Oops!", 'Please enter a valid email address',
          isError: true);
      isLoading.value = false;
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);

      // Show success message
      AppUtils.showSnackbar(
          "Success!", 'Password reset email sent successfully');
      // Navigate back after 2 seconds
    } catch (e) {
      AppUtils.showSnackbar("Oops!", e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
