import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:si_angkot/core/utils/app_utils.dart';
import 'package:si_angkot/data/models/student_model.dart';
import 'package:si_angkot/data/models/user_relation.dart';
import 'package:si_angkot/data/models/users_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('Users');
  final DatabaseReference _userRelationRef =
      FirebaseDatabase.instance.ref('UserRelation');

  // Instance kedua untuk operasi pendaftaran student
  FirebaseApp? _secondaryApp;
  FirebaseAuth? _secondaryAuth;

  // Inisialisasi instance kedua
  Future<void> _initializeSecondaryApp() async {
    if (_secondaryApp == null) {
      try {
        _secondaryApp = await Firebase.initializeApp(
            name: 'secondaryApp', options: Firebase.app().options);
        _secondaryAuth = FirebaseAuth.instanceFor(app: _secondaryApp!);
      } catch (e) {
        // Handle jika app sudah ada
        if (e.toString().contains('already exists')) {
          _secondaryApp = Firebase.app('secondaryApp');
          _secondaryAuth = FirebaseAuth.instanceFor(app: _secondaryApp!);
        } else {
          print("TRACKER : Error initializing secondary app: $e");
          rethrow;
        }
      }
    }
  }

  Stream<List<UserModel>> getStudentsByParentStream(String parentId) {
    return _userRelationRef
        .child('$parentId/students')
        .onValue
        .asyncMap((event) async {
      final Map<dynamic, dynamic>? studentsMap = event.snapshot.value as Map?;

      if (studentsMap == null) {
        return <UserModel>[];
      }

      List<Future<UserModel?>> futures = [];

      studentsMap.forEach((studentId, value) {
        if (value == true) {
          futures.add(getUserProfile(studentId.toString()));
        }
      });

      // Tunggu semua future selesai
      final List<UserModel?> results = await Future.wait(futures);
      print("TRACKER : results listen: $results");

      // Filter out null values dan kembalikan list final
      return results.where((user) => user != null).cast<UserModel>().toList();
    });
  }

  Stream<UserModel> getStudentVerificationStream(String studentId) {
    return _userRef.child(studentId).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        // Add userId to the data since it's likely not stored in the DB value
        data['userId'] = studentId;

        return UserModel.fromMap(data, studentId);
      } else {
        throw Exception('Student not found');
      }
    });
  }

  //=========================Firebase Auth=============================
  Future<User?> login(String email, String password) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("TRACKER : Register Success: ${res.user}");
      return res.user;
    } on FirebaseAuthException catch (e) {
      print(
          "TRACKER : Register Error Firebase: ${e.message}"); // Tampilkan error lebih jelas
      AppUtils.showSnackbar("Error", "${e.message}", isError: true);
      return null;
    } catch (e) {
      print(
          "TRACKER : Register Error Catch: ${e.toString()}"); // Tampilkan error lebih jelas
      AppUtils.showSnackbar("Error", "${e.toString()}", isError: true);
      return null;
    }
  }

  Future<User?> registerStudent(String email, String password) async {
    try {
      // Inisialisasi instance kedua Firebase Auth
      await _initializeSecondaryApp();

      // Gunakan instance kedua untuk pendaftaran student
      final res = await _secondaryAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("TRACKER : Register Student Success: ${res.user}");

      // PENTING: Logout dari instance kedua untuk mencegah konflik dengan session parent
      await _secondaryAuth!.signOut();

      return res.user;
    } on FirebaseAuthException catch (e) {
      print("TRACKER : Register Student Error Firebase: ${e.message}");
      return null;
    } catch (e) {
      print("TRACKER : Register Student Error Catch: ${e.toString()}");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  //=========================Firebase Database=============================

  //add user to database
  Future<void> createUserProfile(UserModel user) async {
    try {
      print('TRACKER : on createUserProfile');
      await _userRef.child(user.userId).set(user.toMap());
    } catch (e) {
      AppUtils.showSnackbar(
          'Profile Error', 'Failed to create user profile: ${e.toString()}',
          isError: true);
    }
  }

  //get user profile from database
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final snapshot = await _userRef.child(userId).get();
      if (snapshot.exists) {
        return UserModel.fromMap(
          Map<String, dynamic>.from(snapshot.value as Map),
          userId,
        );
      }
      return null;
    } catch (e) {
      AppUtils.showSnackbar(
          'Profile Error', 'Failed to fetch user profile: ${e.toString()}',
          isError: true);
      return null;
    }
  }

  //update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _userRef.child(user.userId).update(user.toMap());
    } catch (e) {
      AppUtils.showSnackbar(
          'Update Error', 'Failed to update profile: ${e.toString()}',
          isError: true);
    }
  }

  // Student Data Operations
  Future<void> updateStudentData(String userId, StudentModel data) async {
    try {
      await _userRef.child('$userId/student-data').update(data.toMap());
    } catch (e) {
      AppUtils.showSnackbar(
          'Update Error', 'Failed to update student data: ${e.toString()}',
          isError: true);
    }
  }

  Future<String?> registerAndAddStudent(String parentId, String email,
      String password, UserModel studentData) async {
    try {
      // Register student dengan instance kedua Firebase Auth
      final studentUser = await registerStudent(email, password);

      if (studentUser == null) {
        return null;
      }

      // Set userId dari hasil pendaftaran
      final String studentId = studentUser.uid;
      studentData.userId = studentId;

      // Buat profil student
      await createUserProfile(studentData);

      // Tambahkan relasi parent-student
      await addStudentToParent(parentId, studentId);

      return studentId;
    } catch (e) {
      AppUtils.showSnackbar(
          'Register Error', 'Failed to register student: ${e.toString()}',
          isError: true);
      return null;
    }
  }

  // Parent-Student Relationship Operations
  Future<void> addStudentToParent(String parentId, String studentId) async {
    try {
      await _userRelationRef.child('$parentId/students/$studentId').set(true);
    } catch (e) {
      AppUtils.showSnackbar(
          'Relation Error', 'Failed to add student: ${e.toString()}',
          isError: true);
    }
  }

  Future<void> removeStudentFromParent(
      String parentId, String studentId) async {
    try {
      await _userRelationRef.child('$parentId/students/$studentId').remove();
    } catch (e) {
      AppUtils.showSnackbar(
          'Relation Error', 'Failed to remove student: ${e.toString()}',
          isError: true);
    }
  }

  Future<UserRelation?> getParentRelations(String parentId) async {
    try {
      final snapshot = await _userRelationRef.child(parentId).get();
      if (snapshot.exists) {
        return UserRelation.fromMap(
          Map<String, dynamic>.from(snapshot.value as Map),
          parentId,
        );
      }
      return null;
    } catch (e) {
      AppUtils.showSnackbar(
          'Relation Error', 'Failed to fetch relations: ${e.toString()}',
          isError: true);
      return null;
    }
  }

  Future<List<UserModel>> getStudentsByParent(String parentId) async {
    try {
      final relations = await getParentRelations(parentId);
      if (relations == null) return [];

      final List<UserModel> students = [];
      for (var studentId in relations.students.keys) {
        final user = await getUserProfile(studentId);
        if (user != null) students.add(user);
      }
      return students;
    } catch (e) {
      AppUtils.showSnackbar(
          'Relation Error', 'Failed to load students: ${e.toString()}',
          isError: true);
      return [];
    }
  }

  // Verification Operations
  Future<void> verifyStudent(String studentId, String trackingId) async {
    try {
      await _userRef.child('$studentId/student-data').update({
        'isVerify': true,
        'trackingId': trackingId,
      });
    } catch (e) {
      AppUtils.showSnackbar(
          'Verification Error', 'Failed to verify student: ${e.toString()}',
          isError: true);
    }
  }

  // Search Operations
  Future<UserModel?> searchStudentByNISN(String nisn) async {
    try {
      final query = _userRef.orderByChild('student-data/nisn').equalTo(nisn);
      final snapshot = await query.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> value = snapshot.value as Map;
        final String studentId = value.keys.first;
        return UserModel.fromMap(
          Map<String, dynamic>.from(value[studentId] as Map),
          studentId,
        );
      }
      return null;
    } catch (e) {
      AppUtils.showSnackbar(
          'Search Error', 'Failed to search student: ${e.toString()}',
          isError: true);
      return null;
    }
  }

  Future<UserModel?> getUserIdByNISN(String nisn) async {
    final databaseRef = FirebaseDatabase.instance.ref().child('Users');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      for (final entry in data.entries) {
        final userId = entry.key;
        final userData = entry.value as Map<dynamic, dynamic>;

        UserModel user = UserModel.fromMap(
          Map<String, dynamic>.from(userData),
          userId,
        );

        if (userData['nisn'] == nisn) {
          return user;
        }
      }
    }

    return null; // jika tidak ditemukan
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        AppUtils.showSnackbar(
            'Reset Password', 'Password reset email sent successfully.');
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthException(e));
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
