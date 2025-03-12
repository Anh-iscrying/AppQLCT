import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'analysis_screen.dart';
import 'auth_provider.dart';
import 'forget_password_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'change_language_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider( // Bọc MaterialApp trong ChangeNotifierProvider
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Quản Lý Chi Tiêu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MainPage(), // Sử dụng MainPage làm trang chủ
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
        '/forget-password': (context) => ForgetPasswordScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/edit-profile': (context) => EditProfileScreen(),
        '/change-language': (context) => ChangeLanguageScreen(),
      },
    );
  }
}

class MainPage extends StatelessWidget { // Chuyển sang StatelessWidget
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>( // Lắng nghe trạng thái đăng nhập
      builder: (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          return MainScreen(); // Hiển thị màn hình chính
        } else {
          return SignInScreen(); // Hiển thị màn hình đăng nhập
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    Text(
      'Index 2: Thêm',
      style: optionStyle,
    ),
    AnalysisScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Phân Tích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài Khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF5F5F5),
        onTap: _onItemTapped,
      ),
    );
  }
}