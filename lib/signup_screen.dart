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

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

                // Nhập Họ Tên
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

                // Nhập Email
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

                // Ngày Sinh
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

                // Nhập Mật Khẩu
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    _password = value;
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Xác nhận Mật Khẩu
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Xác nhận Mật Khẩu',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (value != _password) {
                      return 'Mật khẩu không khớp';
                    }
                    _confirmPassword = value;
                    return null;
                  },
                ),
                SizedBox(height: 32.0),

                // Nút Đăng Ký
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      bool success = await authProvider.signUp(_name, _email, _password, _selectedDate);

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đăng ký thất bại. Vui lòng thử lại.')),
                        );
                      }
                    }
                  },
                  child: Text('Đăng Ký', style: TextStyle(fontSize: 18, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
<<<<<<< HEAD
                    backgroundColor: Colors.amber,
=======
                    backgroundColor: Color(0xFFE95B1E),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Đã có tài khoản? Đăng nhập
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Đã có tài khoản? Đăng nhập",
                      style: TextStyle(
<<<<<<< HEAD
                        color: Colors.black,
=======
                        color: Color(0xFFE95B1E),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
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
