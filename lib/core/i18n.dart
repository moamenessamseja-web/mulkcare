import 'dart:convert';

import 'package:flutter/services.dart';

class AppTranslations {
  AppTranslations({required this.ar, required this.en});

  final Map<String, dynamic> ar;
  final Map<String, dynamic> en;

  static Future<AppTranslations> load() async {
    final arJson = await rootBundle.loadString('assets/i18n/ar.json');
    final enJson = await rootBundle.loadString('assets/i18n/en.json');
    return AppTranslations(
      ar: jsonDecode(arJson) as Map<String, dynamic>,
      en: jsonDecode(enJson) as Map<String, dynamic>,
    );
  }

  String text(String locale, String key, {Map<String, Object?> values = const {}}) {
    dynamic value = locale == 'en' ? en : ar;
    for (final part in key.split('.')) {
      if (value is! Map<String, dynamic>) return key;
      value = value[part];
    }
    if (value is! String) return key;
    var result = value;
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', '${entry.value}');
    }
    return result;
  }

  String localized(Map<String, dynamic> value, String locale) {
    final selected = value[locale];
    final fallback = value[locale == 'en' ? 'ar' : 'en'];
    return (selected ?? fallback ?? '').toString();
  }
}
