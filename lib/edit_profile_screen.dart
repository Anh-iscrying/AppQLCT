import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Lấy thông tin hiện tại từ AuthProvider khi mở màn hình
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      setState(() {
        _name = authProvider.name ?? '';
        _email = authProvider.email ?? '';
        _selectedDate = authProvider.dateOfBirth ?? DateTime.now();
      });
    });
  }

  // Hàm chọn ngày sinh
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Họ Tên
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  hintText: 'Họ Tên',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
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
              const SizedBox(height: 16.0),

              // Email
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  } else if (!value.contains('@')) {
                    return 'Vui lòng nhập email hợp lệ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16.0),

              // Ngày sinh
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Ngày sinh',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(_selectedDate),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),

              // Nút lưu thông tin
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final authProvider = Provider.of<AuthProvider>(context, listen: false);

                    // Gọi updateProfile trong AuthProvider
                    authProvider.updateProfile(
                      name: _name,
                      email: _email,
                      dateOfBirth: _selectedDate,
                    );

                    // Thông báo cập nhật thành công
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Cập nhật thành công"),
                          content: const Text("Thông tin cá nhân của bạn đã được cập nhật."),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                                Navigator.pop(context); // Quay lại màn hình Account
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Lưu thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
