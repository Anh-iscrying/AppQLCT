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

// Đa ngôn ngữ
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAuthProvider()),
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
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      locale: localeProvider.locale, // Gán locale từ provider
      supportedLocales: L10n.all,    // Các locale hỗ trợ
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: MainPage(),
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
    return Consumer<MyAuthProvider>(
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

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    Text(
      'Index 2: Thêm',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('app_title')), // Đã dịch app title
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<MyAuthProvider>(context, listen: false).signOut();
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
            label: loc.translate('home'),      // Trang chủ / Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: loc.translate('calendar'),  // Lịch / Calendar
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: '',                         // Không có label cho nút giữa
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: loc.translate('analysis'),  // Phân tích / Analysis
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: loc.translate('account'),   // Tài khoản / Account
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
