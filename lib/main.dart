import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
import '../providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => MyAuthProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        initialRoute: '/',
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

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Mặc định là false nếu không tìm thấy
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isLoggedIn && FirebaseAuth.instance.currentUser != null) {
      return HomeScreen(uid: FirebaseAuth.instance.currentUser!.uid);
    } else {
      return SignInScreen();
    }
  }
}

// Ví dụ hàm đăng xuất (đặt ở nơi thích hợp trong ứng dụng của bạn):
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
}