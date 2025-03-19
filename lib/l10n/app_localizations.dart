import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    try {
      String jsonString =
      await rootBundle.loadString('l10n/i18n_${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      if (jsonMap.isEmpty) {
        print('File localization rỗng: l10n/i18n_${locale.languageCode}.json');
        _localizedStrings = {};
        return false;
      }

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      print('Lỗi load file localization: $e');
      _localizedStrings = {}; // Hoặc set một giá trị mặc định
      return false; // Báo hiệu load thất bại
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static List<Locale> supportedLocales = [
    const Locale('en', 'US'), // English, United States
    const Locale('vi', 'VN'), // Vietnamese, Vietnam
  ];

  static Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    AppLocalizations.delegate,
  ];
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale); // Check using supportedLocales
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}