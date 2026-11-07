import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_bundle.dart';

class AppStore extends ChangeNotifier {
  static const _sessionKey = 'mulkcare.session.v1';
  static const _bundleKey = 'mulkcare.bundle.v1';
  static const _langKey = 'mulkcare.lang.v1';

  AppBundle? _bundle;
  Map<String, dynamic>? _session;
  Locale _locale = const Locale('ar');
  bool _loading = true;

  bool get isAuthenticated => _session != null;
  bool get isLoading => _loading;
  AppBundle? get bundle => _bundle;
  Locale get locale => _locale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString(_langKey);
    if (lang != null) _locale = Locale(lang);
    final sessionRaw = prefs.getString(_sessionKey);
    if (sessionRaw != null) {
      try { _session = jsonDecode(sessionRaw); } catch (_) {}
    }
    final bundleRaw = prefs.getString(_bundleKey);
    if (bundleRaw != null) {
      try { _bundle = AppBundle.fromJson(jsonDecode(bundleRaw)); } catch (_) {}
    }
    _bundle ??= AppBundle.seed();
    _loading = false;
    notifyListeners();
  }

  Future<void> signIn(String email) async {
    _session = {'userId': 'usr_1001', 'issuedAt': DateTime.now().toIso8601String(), 'mode': 'demo'};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(_session));
    notifyListeners();
  }

  Future<void> signOut() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }

  void setLocale(String lang) async {
    _locale = Locale(lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang);
    notifyListeners();
  }
}
