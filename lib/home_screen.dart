import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)], // Màu gradient nhẹ nhàng
          ),
        ),
        child: Center(
          child: authProvider.isLoggedIn ? _buildLoggedInUI(context) : _buildLoggedOutUI(context),
        ),
      ),
    );
  }

  Widget _buildLoggedOutUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Hình ảnh minh họa
        Image.asset('assets/icons/mn.png', // Thay thế bằng đường dẫn hình ảnh của bạn
          height: 150,
        ),
        SizedBox(height: 32),

        // Tiêu đề và mô tả
        Text(
          'Welcome to our w---d!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          'Quản lý chi tiêu dễ dàng và hiệu quả hơn bao giờ hết.',
          style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 48),

        // Nút Đăng nhập và Đăng ký
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signin');
          },
          child: Text('Đăng nhập', style: TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEFBA76),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: Text('Đăng ký', style: TextStyle(fontSize: 16, color: Color(
              0xFFEDBC84))),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: Color(0xFFEF8341)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedInUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chào mừng trở lại!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(
                0xFFE95B1E)),
          ),
          SizedBox(height: 16),
          Text(
            'Bạn đã sẵn sàng quản lý chi tiêu chưa?',
            style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Điều hướng đến màn hình chính của ứng dụng (ví dụ: MainPage)
              Navigator.pushReplacementNamed(context, '/main'); // Thay '/main' bằng route chính xác
            },
            child: Text('Bắt đầu', style: TextStyle(fontSize: 16, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE95B1E),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}