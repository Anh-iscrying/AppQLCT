import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (authProvider.currentUser != null)
                Text(
                  'Xin chào, ${authProvider.currentUser!['name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

              SizedBox(height: 20),

              // Mật khẩu cũ
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu cũ';
                  }
                  return null;
                },
              ),

              // Mật khẩu mới
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Mật khẩu mới'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  return null;
                },
              ),

              // Xác nhận mật khẩu mới
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final oldPassword = _oldPasswordController.text.trim();
                    final newPassword = _newPasswordController.text.trim();

                    bool success = authProvider.changePassword(oldPassword, newPassword);

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mật khẩu cũ không đúng!')),
                      );
                      return;
                    }
<<<<<<< HEAD
                  },
                  child: Text('Đổi Mật Khẩu', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.amber,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ],
            ),
=======

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Đổi mật khẩu thành công"),
                          content: Text("Bạn đã đổi mật khẩu thành công."),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Đổi mật khẩu'),
              ),
            ],
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
          ),
        ),
      ),
    );
  }
}
