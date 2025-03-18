import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  DateTime _selectedDate = DateTime.now();
  String _tempPassword = ''; // Biến tạm thời để lưu trữ mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tiêu đề
                Text(
                  "Chào người dùng mới!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  "Chào mừng bạn đến với ứng dụng",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),

                // Trường Nhập Họ Tên
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Họ Tên',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16.0),

                // Trường Nhập Email
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                SizedBox(height: 16.0),

                // GENDER SELECTION - NEED CUSTOM WIDGET
                // Thay vì TextFormField, cần dùng một widget tùy chỉnh để chọn giới tính
                // Ví dụ: Row với các RadioButton hoặc Button có style riêng

                SizedBox(height: 16.0),

                // Trường Nhập Ngày Sinh - Cần Custom DatePicker
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Trường Nhập Mật Khẩu
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Mật Khẩu',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tempPassword = value!; // Lưu vào biến tạm thời
                    setState(() {}); // Cập nhật lại widget
                  },
                  autofillHints: null,
                ),
                SizedBox(height: 16.0),

                // Trường Xác Nhận Mật Khẩu
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Xác nhận mật khẩu',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _tempPassword) { // So sánh với biến tạm thời
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = _tempPassword; // Gán lại cho biến password sau khi validate
                    _confirmPassword = value!;
                  },
                  autofillHints: null,
                ),

                SizedBox(height: 32.0),

                // Nút Đăng Ký
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save(); // Lưu trước khi validate
                    if (_formKey.currentState!.validate()) {

                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      bool success = await authProvider.signUp(_name, _email, _password, _selectedDate);

                      if (success) {
                        // Đăng ký thành công, tự động đăng nhập
                        bool loginSuccess = await authProvider.signIn(_email, _password);
                        if (loginSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        } else {
                          // Xử lý lỗi đăng nhập (nếu có)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đăng nhập tự động thất bại.')),
                          );
                          Navigator.pushReplacementNamed(context, '/signin'); // Chuyển đến màn hình đăng nhập
                        }
                      } else {
                        // Xử lý lỗi đăng ký
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
                        );
                        Navigator.pushReplacementNamed(context, '/signin'); // Chuyển đến màn hình đăng nhập
                      }
                    }
                  },
                  child: Text('Đăng Ký', style: TextStyle(fontSize: 18, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.amber,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Đã có tài khoản? Đăng nhập ngay
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Điều hướng đến màn hình Đăng Nhập
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text(
                      "Đã có tài khoản? Đăng nhập ngay",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}