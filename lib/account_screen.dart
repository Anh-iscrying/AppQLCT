import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'home_screen.dart'; // Import HomeScreen

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chỉnh sửa thông tin cá nhân cùng các cài đặt khác',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Mai Phương Anh',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        'Tiền hàng tháng',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/originals/0c/3b/3a/0c3b3ab9cf9c9a14f6c9dfafac358f33.jpg'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '30.000.000 VND',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),

                    _buildOption(context, Icons.person, 'Tài Khoản'),
                    _buildOption(context, Icons.lock, 'Đổi Mật Khẩu'),
                    _buildOption(context, Icons.language, 'Ngôn Ngữ'),
                    _buildOption(context, Icons.brightness_2, 'Chế Độ Tối', showSwitch: true),
                    _buildOption(context, Icons.history, 'Lịch Sử'),
                    _buildOption(context, Icons.save_alt, 'Xuất CSV'),
                    _buildOption(context, Icons.attach_money, 'Tỷ Giá Tiền Tệ'),

                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        authProvider.signOut(); // ĐÃ SỬA LỖI
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text('Đăng xuất', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, {bool showSwitch = false}) {
    String routeName = '';
    if (title == 'Đổi Mật Khẩu') {
      routeName = '/change-password';
    } else if (title == 'Tài Khoản') {
      routeName = '/edit-profile';
    } else if (title == 'Ngôn Ngữ') {
      routeName = '/change-language';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          if (routeName.isNotEmpty) {
            Navigator.pushNamed(context, routeName);
          }
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (showSwitch)
              Switch(value: false, onChanged: (value) {}),
            if (!showSwitch)
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}