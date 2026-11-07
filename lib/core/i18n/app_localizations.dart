import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('ar'), Locale('en')];
  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(const Locale('ar'));
  }

  static const _strings = {
    'ar': {
      'appName': 'MulkCare',
      'nav.home': 'الرئيسية',
      'nav.services': 'الخدمات',
      'nav.local': 'الدليل المحلي',
      'nav.profile': 'حسابي',
      'auth.title': 'تسجيل الدخول',
      'auth.emailOrPhone': 'البريد الإلكتروني أو رقم الهاتف',
      'auth.password': 'كلمة المرور',
      'auth.login': 'تسجيل الدخول',
    },
    'en': {
      'appName': 'MulkCare',
      'nav.home': 'Home',
      'nav.services': 'Services',
      'nav.local': 'Local guide',
      'nav.profile': 'Account',
      'auth.title': 'Sign in',
      'auth.emailOrPhone': 'Email or phone number',
      'auth.password': 'Password',
      'auth.login': 'Sign in',
    },
  };

  String t(String key) {
    final map = _strings[locale.languageCode] ?? _strings['ar']!;
    return map[key] ?? key;
  }
}
