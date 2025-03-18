import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _currentUser; // Người dùng hiện tại sau khi đăng nhập
  final List<Map<String, dynamic>> _users = []; // Danh sách tất cả user đã đăng ký

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get currentUser => _currentUser;

  // Thêm các getter cho name, email và birthDate để dùng bên EditProfilePage
  String get name => _currentUser?['name'] ?? '';
  String get email => _currentUser?['email'] ?? '';
  DateTime? get dateOfBirth => _currentUser?['birthDate'];

  /// Đăng ký tài khoản mới
  Future<bool> signUp(String name, String email, String password, DateTime birthDate) async {
    // Kiểm tra email đã tồn tại chưa
    final userExists = _users.any((user) => user['email'] == email);

    if (userExists) {
      print('Email đã tồn tại!');
      return false;
    }

    // Tạo user mới có thêm trường transactions
    final newUser = {
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate,
      'transactions': <Map<String, dynamic>>[], // Quản lý giao dịch riêng cho user này
    };

    _users.add(newUser);

    print('Đã đăng ký user mới: $newUser');
    print('Danh sách user hiện tại: $_users');

    await Future.delayed(Duration(seconds: 1)); // Giả lập delay
    return true;
  }

  /// Đăng nhập
  Future<bool> signIn(String email, String password) async {
    print('Đang đăng nhập với: $email / $password');

    try {
      final user = _users.firstWhere(
            (u) => u['email'] == email && u['password'] == password,
      );

      _isLoggedIn = true;
      _currentUser = user;
      notifyListeners();

      print('Đăng nhập thành công với user: $_currentUser');
      return true;
    } catch (e) {
      print('Đăng nhập thất bại. Email hoặc mật khẩu không đúng.');
      return false;
    }
  }

  /// Đăng xuất
  void signOut() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
    print('Đã đăng xuất!');
  }

  /// In danh sách user cho dễ debug
  void printAllUsers() {
    print('Danh sách users hiện tại: $_users');
  }

  /// Thêm giao dịch mới cho user hiện tại
  void addTransaction(String type, double amount, {String? note}) {
    if (_currentUser == null) {
      print('Chưa đăng nhập!');
      return;
    }

    final transaction = {
      'type': type, // 'income' hoặc 'expense'
      'amount': amount,
      'note': note ?? '',
      'date': DateTime.now(),
    };

    // Thêm vào transactions của currentUser
    _currentUser!['transactions'].add(transaction);

    // Đồng bộ lại _users list (cập nhật user bên trong _users)
    final userIndex = _users.indexWhere((user) => user['email'] == _currentUser!['email']);
    if (userIndex != -1) {
      _users[userIndex] = _currentUser!;
    }

    notifyListeners();
    print('Đã thêm giao dịch: $transaction');
  }

  /// Lấy danh sách giao dịch của user hiện tại
  List<Map<String, dynamic>> getTransactions() {
    if (_currentUser == null) {
      print('Chưa đăng nhập!');
      return [];
    }

    return List<Map<String, dynamic>>.from(_currentUser!['transactions']);
  }

  /// Đổi mật khẩu user hiện tại
  bool changePassword(String currentPassword, String newPassword) {
    if (_currentUser == null) {
      print('Chưa đăng nhập!');
      return false;
    }

    if (_currentUser!['password'] != currentPassword) {
      print('Mật khẩu hiện tại không đúng!');
      return false;
    }

    // Cập nhật mật khẩu mới
    _currentUser!['password'] = newPassword;

    // Đồng bộ lại _users list
    final userIndex = _users.indexWhere((user) => user['email'] == _currentUser!['email']);
    if (userIndex != -1) {
      _users[userIndex] = _currentUser!;
    }

    notifyListeners();
    print('Đã đổi mật khẩu thành công!');
    return true;
  }

  /// Cập nhật thông tin user (cho EditProfilePage)
  void updateProfile({
    required String name,
    required String email,
    required DateTime dateOfBirth,
  }) {
    if (_currentUser == null) {
      print('Chưa đăng nhập!');
      return;
    }

    print('Cập nhật thông tin user...');

    // Cập nhật thông tin người dùng hiện tại
    _currentUser!['name'] = name;
    _currentUser!['email'] = email;
    _currentUser!['birthDate'] = dateOfBirth;

    // Đồng bộ lại danh sách user (giả lập cơ sở dữ liệu)
    final userIndex = _users.indexWhere((user) => user['email'] == _currentUser!['email']);
    if (userIndex != -1) {
      _users[userIndex] = _currentUser!;
    }

    notifyListeners();
    print('Cập nhật hồ sơ thành công: $_currentUser');
  }
}
