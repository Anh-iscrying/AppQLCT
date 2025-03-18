import 'package:flutter/material.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _selectedLanguage = 'vi'; // Ngôn ngữ mặc định là tiếng Việt

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC),
        appBar:PreferredSize(
        preferredSize: Size.fromHeight(65.0),
    child: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Colors.amber,
    Color(0xFFF5F5DC),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
      child: AppBar(
        title: Text('Chọn Ngôn Ngữ'),
        backgroundColor: Colors.transparent,
      ),
    ),
        ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chọn ngôn ngữ bạn muốn sử dụng:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 24.0),

              // Radio Button cho Tiếng Việt
              RadioListTile(
                title: Text('Tiếng Việt'),
                value: 'vi',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),

              // Radio Button cho Tiếng Anh
              RadioListTile(
                title: Text('English'),
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Pháp'),
                value: 'fr',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Đức'),
                value: 'ger',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Ý'),
                value: 'ita',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Nhật'),
                value: 'ja',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Hàn'),
                value: 'ko',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
              RadioListTile(
                title: Text('Tiếng Trung'),
                value: 'chi',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    // TODO: Lưu ngôn ngữ đã chọn vào SharedPreferences hoặc Provider
                    // Ví dụ:
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.setString('language', _selectedLanguage);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}