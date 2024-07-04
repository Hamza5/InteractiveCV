import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'theme_settings.dart';


class LanguageSwitch extends StatelessWidget {

  static const supportedLocalesFlagPaths = {
    'ar': 'images/flags/arab-league.png',
    'en': 'images/flags/united-states.png',
    'fr': 'images/flags/france.png',
    'zh': 'images/flags/china.png',
  };
  static String flagImageForLangCode(String langCode) {
    return supportedLocalesFlagPaths[langCode] ?? '';
  }

  String nextLangCode(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final currentIndex = AppLocalizations.supportedLocales.indexOf(currentLocale);
    return AppLocalizations.supportedLocales[(currentIndex + 1) % AppLocalizations.supportedLocales.length].languageCode;
  }

  final ValueNotifier<ThemeSettings> themeNotifier;
  const LanguageSwitch({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: () {
        themeNotifier.value = ThemeSettings(
          colorIndex: themeNotifier.value.colorIndex, dark: themeNotifier.value.dark,
          lang: nextLangCode(context),
        );
      },
      child: Image.asset(flagImageForLangCode(nextLangCode(context)), width: 50, height: 50),
    );
  }
}