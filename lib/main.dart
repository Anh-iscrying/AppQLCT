import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Các màn hình và provider khác
import 'signup_screen.dart';
import 'signin_screen.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'analysis_screen.dart';
import 'providers/auth_provider.dart';
import 'forget_password_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'change_language_screen.dart';

// Thêm import cho đa ngôn ngữ
import 'l10n/app_localizations.dart'; // File gen từ ARB
import 'providers/locale_provider.dart'; // Provider quản lý locale

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ứng dụng Quản Lý Chi Tiêu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      locale: localeProvider.locale, // Set locale ở đây!
      supportedLocales: L10n.all,     // Danh sách locale hỗ trợ
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MainPage(), // Trang chủ
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

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoggedIn) {
          return MainScreen();
        } else {
          return SignInScreen();
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
    var loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('app_title')), // tiêu đề có thể dịch
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: loc.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: loc.translate('calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: loc.translate('analysis'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: loc.translate('account'),
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
