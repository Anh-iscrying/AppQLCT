import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signin_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    // Định nghĩa ThemeData cho chế độ sáng và tối
    final ThemeData theme = _isDarkMode
        ? ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.grey[850],
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
      cardColor: Colors.grey[800],
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.purple[200];
          }
          return Colors.grey[400];
        }),
      ),
    )
        : ThemeData.light().copyWith(
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      appBarTheme: AppBarTheme(backgroundColor: Colors.amber),
      cardColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.amber),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.amber;
          }
          return Colors.grey[400];
        }),
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: Container(
          decoration: const BoxDecoration(
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
            title: const Text('Quản lý chi tiêu'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chỉnh sửa thông tin cá nhân cùng các cài đặt khác',
                style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color, fontSize: 14),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: theme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          user?.displayName ?? 'Không có tên', // Hiển thị tên người dùng
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: theme.textTheme.titleMedium?.color),
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          'Tiền hàng tháng',
                          style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 14),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: theme.textTheme.bodyLarge?.color),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      _buildOption(context, Icons.person, 'Tài Khoản', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      _buildOption(context, Icons.lock, 'Đổi Mật Khẩu', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      _buildOption(context, Icons.language, 'Ngôn Ngữ', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      _buildOption(context, Icons.brightness_2, 'Chế Độ Tối', showSwitch: true, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode, theme: theme),
                      _buildOption(context, Icons.history, 'Lịch Sử', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      _buildOption(context, Icons.save_alt, 'Xuất CSV', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      _buildOption(context, Icons.attach_money, 'Tỷ Giá Tiền Tệ', theme: theme, isDarkMode: _isDarkMode, toggleDarkMode: _toggleDarkMode),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          authProvider.signOut(); // ĐÃ SỬA LỖI
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInScreen()),
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
      ),
    );
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, {bool showSwitch = false, bool isDarkMode = false, VoidCallback? toggleDarkMode, required ThemeData theme}) {
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
            Icon(icon, color: theme.iconTheme.color, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            if (showSwitch)
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  toggleDarkMode?.call(); // Gọi hàm toggle
                },
                thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.purple[200];
                  }
                  return Colors.grey[400];
                }),
              ),
            if (!showSwitch)
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}