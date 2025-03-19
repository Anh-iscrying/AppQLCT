import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import '../providers/transaction_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
=======
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core
>>>>>>> c1d76072e5774d74fdaa7ce1d235d6383481f81f

import 'signup_screen.dart';
import 'signin_screen.dart';
import 'account_screen.dart';
import 'providers/auth_provider.dart';
import 'forget_password_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'change_language_screen.dart';
import '../screens/home_screen.dart';

import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

<<<<<<< HEAD
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
=======
void main() async { // Thêm async
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter được khởi tạo
  await Firebase.initializeApp(); // Khởi tạo Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
>>>>>>> c1d76072e5774d74fdaa7ce1d235d6383481f81f
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        localizationsDelegates: [
          AppLocalizations.delegate, // Sử dụng delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all, // Sử dụng danh sách locales từ L10n
        locale: Provider.of<LocaleProvider>(context).locale,
        initialRoute: '/', // Route mặc định
        routes: {
          '/': (context) => AuthCheck(),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
          '/forget-password': (context) => ForgetPasswordScreen(),
          '/change-password': (context) => ChangePasswordScreen(),
          '/edit-profile': (context) => EditProfileScreen(),
          '/change-language': (context) => ChangeLanguageScreen(),
        },
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen(uid: snapshot.data!.uid);
        } else {
          return SignInScreen();
        }
      },
    );
  }
<<<<<<< HEAD
}
=======
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
              label: loc.translate('home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: loc.translate('calendar')),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: loc.translate('analysis')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: loc.translate('account')),
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
>>>>>>> c1d76072e5774d74fdaa7ce1d235d6383481f81f
