import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
}