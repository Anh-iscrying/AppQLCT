import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'main.dart';
import '../providers/locale_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _selectedLanguage = 'vi';

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Color(0xFFF5F5DC),
        appBar:PreferredSize(
        preferredSize: Size.fromHeight(65.0),
    child: Container(
    decoration: BoxDecoration(
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
        title: Text('Chọn Ngôn Ngữ'),
        backgroundColor: Colors.transparent,
=======
      backgroundColor: Color(0xFFFCE4EC),
      appBar: AppBar(
        title: Text(loc.translate('language_screen_title')),
        backgroundColor: Color(0xFFEF8341),
>>>>>>> d569476e8bd6c44b72edb10c85a9114b343a5644
      ),
    ),
        ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.translate('select_language_text'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 24.0),
              RadioListTile(
                title: Text(loc.translate('vietnamese')),
                value: 'vi',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _changeLanguage(context, 'vi');
                },
              ),
              RadioListTile(
                title: Text(loc.translate('english')),
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _changeLanguage(context, 'en');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(Locale(languageCode));
  }
}
