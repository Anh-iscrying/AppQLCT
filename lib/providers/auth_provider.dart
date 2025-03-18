/*
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signIn(String email, String password) async {
    // Thay thế bằng logic đăng nhập thực tế của bạn (ví dụ: gọi API)
    await Future.delayed(Duration(seconds: 2)); // Giả lập đăng nhập thành công

    if (email == 'test@example.com' && password == 'password') {
      _isLoggedIn = true;
      notifyListeners(); // Thông báo cho các widgets lắng nghe
      return true;
    } else {
      return false;
    }
  }

  void signOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
 */

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _tempEmail; // Lưu email tạm thời sau khi đăng ký
  String? _tempPassword; // Lưu mật khẩu tạm thời sau khi đăng ký

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signIn(String email, String password) async {
    // Nếu có thông tin đăng nhập tạm thời, sử dụng nó
    if (_tempEmail != null && _tempPassword != null) {
      if (email == _tempEmail && password == _tempPassword) {
        _isLoggedIn = true;
        _tempEmail = null; // Xóa thông tin đăng nhập tạm thời
        _tempPassword = null;
        notifyListeners();
        return true;
      }
      // Nếu thông tin không khớp, coi như đăng nhập thất bại
      return false;
    }
    // Thay thế bằng logic đăng nhập thực tế của bạn (ví dụ: gọi API)
    await Future.delayed(Duration(seconds: 2)); // Giả lập đăng nhập thành công

    if (email == 'test@example.com' && password == 'password') {
      _isLoggedIn = true;
      notifyListeners(); // Thông báo cho các widgets lắng nghe
      return true;
    } else {
      return false;
    }
  }

  void signOut() {
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> signUp(String name, String email, String password, DateTime birthDate) async {
    // **TODO:** Gọi API hoặc lưu thông tin vào backend

    // Lưu thông tin đăng nhập tạm thời
    _tempEmail = email;
    _tempPassword = password;

    await Future.delayed(Duration(seconds: 2)); // Giả lập quá trình đăng ký
    return true;
  }
}