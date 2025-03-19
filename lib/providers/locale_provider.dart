// providers/locale_provider.dart
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi'); // Mặc định là tiếng Việt

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return; // Kiểm tra nếu locale hợp lệ
    _locale = locale;
    notifyListeners(); // Thông báo cho widget rebuild
  }

  void clearLocale() {
    _locale = const Locale('vi'); // Hoặc Locale mặc định
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('vi'),
  ];
}