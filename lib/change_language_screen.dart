import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _selectedLanguage = 'vi';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy locale hiện tại từ LocaleProvider và cập nhật _selectedLanguage
    _selectedLanguage = Provider.of<LocaleProvider>(context).locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
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
            title: Text(loc?.translate('select_language') ?? 'Chọn Ngôn Ngữ'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (loc != null)
                Text(
                  loc.translate('select_language_text'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                )
              else
                const Text("Loading..."),
              const SizedBox(height: 24.0),
              RadioListTile(
                title: Text(loc?.translate('vietnamese') ?? "Vietnamese"),
                value: 'vi',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    _changeLanguage(context, value);
                  }
                },
              ),
              RadioListTile(
                title: Text(loc?.translate('english') ?? "English"),
                value: 'en',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    _changeLanguage(context, value);
                  }
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