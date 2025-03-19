import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  String get name => _currentUser?.displayName ?? '';
  String get email => _currentUser?.email ?? '';

  Future<bool> signUp(String name, String email, String password, DateTime birthDate) async {
    // This method is no longer responsible for creating the user.
    // The SignUpScreen now handles that using FirebaseAuth.instance.createUserWithEmailAndPassword.

    // **TODO:** Consider adding logic here to save additional user information (name, birthDate) to Firestore
    // after the user is successfully created in Firebase Authentication.

    return true; // Just return true since the actual user creation is done in the SignUpScreen.
  }

  Future<bool> signIn(String email, String password) async {
    // This method is no longer needed as the SignInScreen now directly uses FirebaseAuth.instance.signInWithEmailAndPassword.
    // You can remove it or leave it as an empty function.
    return true;
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    print('Đã đăng xuất!');
  }

  /// Đổi mật khẩu user hiện tại
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Chưa đăng nhập!');
        return false;
      }

      // Re-authenticate user (required for changing password)
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      print('Đã đổi mật khẩu thành công!');
      return true;
    } catch (e) {
      print('Lỗi đổi mật khẩu: $e');
      return false;
    }
  }

  /// Cập nhật thông tin user (cho EditProfilePage)
  Future<void> updateProfile({
    required String name,
    required String email,
    required DateTime dateOfBirth,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Chưa đăng nhập!');
      return;
    }

    try {
      // Update display name
      await user.updateDisplayName(name);

      // **TODO:** Consider saving the updated email and birthDate to Firestore as well.

      notifyListeners();
      print('Cập nhật hồ sơ thành công!');
    } catch (e) {
      print('Lỗi cập nhật hồ sơ: $e');
    }
  }
}