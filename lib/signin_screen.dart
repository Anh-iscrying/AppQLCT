import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'providers/auth_provider.dart';
import 'main.dart'; // Import để có thể điều hướng đến MainPage
=======
import 'auth_provider.dart';
import 'main.dart';
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true; // Thêm biến để kiểm soát hiển thị mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Color(0xFFF5F5DC),
      appBar: null, // Ẩn AppBar cho màn hình đăng nhập
=======
      backgroundColor: Color(0xFFFCE4EC),
      appBar: null,
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Chào mừng trở lại!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  "Đăng nhập để tiếp tục",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),

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

                // Nhập Mật Khẩu có ẩn/hiện
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
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),

                SizedBox(height: 32.0),

                // Nút Đăng Nhập
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);

                      authProvider.printAllUsers();

                      bool success = await authProvider.signIn(_email, _password);

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại email và mật khẩu.')),
                        );
                      }
                    }
                  },
                  child: Text('Đăng Nhập', style: TextStyle(fontSize: 18, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
<<<<<<< HEAD
                    backgroundColor: Colors.amber,
=======
                    backgroundColor: Color(0xFFEF8341),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Đăng ký ngay
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "Chưa có tài khoản? Đăng ký ngay",
                      style: TextStyle(
<<<<<<< HEAD
                        color: Colors.black,
=======
                        color: Color(0xFFF4A675),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.0),

                // Quên mật khẩu
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forget-password');
                    },
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
<<<<<<< HEAD
                        color: Colors.black,
=======
                        color: Color(0xFFEF8341),
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
