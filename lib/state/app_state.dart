import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/format.dart';
import '../core/i18n.dart';
import '../data/demo_data.dart';
import '../data/models.dart';

class AppState extends ChangeNotifier {
  AppState._(this.translations, this._preferences) {
    final demo = DemoData.create();
    properties = List<PropertyModel>.from(demo['properties'] as List);
    plans = List<PlanModel>.from(demo['plans'] as List);
    _requests = List<ServiceRequestModel>.from(demo['requests'] as List);
    inspectionReports = List<InspectionReportModel>.from(demo['reports'] as List);
    _subscriptions = List<SubscriptionModel>.from(demo['subscriptions'] as List);
    invoices = List<InvoiceModel>.from(demo['invoices'] as List);
    _notifications = List<NotificationModel>.from(demo['notifications'] as List);
    upcomingVisits = List<VisitModel>.from(demo['visits'] as List);
    _restore();
  }

  final AppTranslations translations;
  final SharedPreferences _preferences;
  late final List<PropertyModel> properties;
  late final List<PlanModel> plans;
  late final List<InspectionReportModel> inspectionReports;
  late final List<InvoiceModel> invoices;
  late final List<VisitModel> upcomingVisits;
  late List<ServiceRequestModel> _requests;
  late List<SubscriptionModel> _subscriptions;
  late List<NotificationModel> _notifications;
  final Map<String, bool> notificationPreferences = {
    'visits': true,
    'maintenance': true,
    'invoices': true,
    'marketing': false,
  };
  String _language = 'ar';
  UserModel? _user;
  int _nextNotification = 10;

  static Future<AppState> create(AppTranslations translations) async {
    final preferences = await SharedPreferences.getInstance();
    return AppState._(translations, preferences);
  }

  String get language => _language;
  bool get isRtl => _language == 'ar';
  UserModel? get user => _user;
  bool get isSignedIn => _user != null;
  List<ServiceRequestModel> get serviceRequests => List.unmodifiable(_requests);
  List<SubscriptionModel> get subscriptions => List.unmodifiable(_subscriptions);
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((item) => !item.read).length;

  String tr(String key, {Map<String, Object?> values = const {}}) =>
      translations.text(_language, key, values: values);
  String text(LocalizedText value) => value.value(_language);

  PropertyModel? propertyById(String? id) {
    for (final property in properties) {
      if (property.id == id) return property;
    }
    return null;
  }

  InspectionReportModel? reportById(String? id) {
    for (final report in inspectionReports) {
      if (report.id == id) return report;
    }
    return null;
  }

  PlanModel? planById(String? id) {
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }

  List<ServiceRequestModel> requestsFor(String propertyId) => _requests
      .where((request) => request.propertyId == propertyId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<InvoiceModel> invoicesFor(String propertyId) => invoices
      .where((invoice) => invoice.propertyId == propertyId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<InspectionReportModel> reportsFor(String propertyId) => inspectionReports
      .where((report) => report.propertyId == propertyId)
      .toList()
    ..sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));

  List<ServiceRequestModel> get openRequests => _requests
      .where((request) => !{'completed', 'cancelled'}.contains(request.status))
      .toList();

  void _restore() {
    _language = _preferences.getString('mulkcare.language') ?? 'ar';
    final userJson = _preferences.getString('mulkcare.user');
    if (userJson != null) {
      try {
        _user = UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(userJson) as Map));
      } catch (_) {
        _user = null;
      }
    }
    final saved = _preferences.getString('mulkcare.demo.state');
    if (saved != null) {
      try {
        final json = Map<String, dynamic>.from(jsonDecode(saved) as Map);
        final requestList = json['requests'] as List?;
        final subscriptionList = json['subscriptions'] as List?;
        final notificationList = json['notifications'] as List?;
        if (requestList != null) {
          _requests = requestList.map((item) => ServiceRequestModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
        }
        if (subscriptionList != null) {
          _subscriptions = subscriptionList.map((item) => SubscriptionModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
        }
        if (notificationList != null) {
          _notifications = notificationList.map((item) => NotificationModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
        }
        final prefs = json['notificationPreferences'];
        if (prefs is Map) {
          for (final key in notificationPreferences.keys) {
            if (prefs[key] is bool) notificationPreferences[key] = prefs[key] as bool;
          }
        }
      } catch (_) {
        // A damaged local demo snapshot is ignored; bundled sample data remains intact.
      }
    }
  }

  Future<void> _persist() async {
    await _preferences.setString('mulkcare.language', _language);
    if (_user == null) {
      await _preferences.remove('mulkcare.user');
    } else {
      await _preferences.setString('mulkcare.user', jsonEncode(_user!.toJson()));
    }
    await _preferences.setString('mulkcare.demo.state', jsonEncode({
      'requests': _requests.map((item) => item.toJson()).toList(),
      'subscriptions': _subscriptions.map((item) => item.toJson()).toList(),
      'notifications': _notifications.map((item) => item.toJson()).toList(),
      'notificationPreferences': notificationPreferences,
    }));
  }

  Future<void> setLanguage(String language) async {
    if (!{'ar', 'en'}.contains(language) || language == _language) return;
    _language = language;
    notifyListeners();
    await _persist();
  }

  String? signIn({required String identity, required String password}) {
    final input = identity.trim();
    final emailLike = input.contains('@') && input.contains('.');
    final phoneLike = input.replaceAll(RegExp(r'[^0-9+]'), '').length >= 8;
    if (!emailLike && !phoneLike) return 'auth.errEmail';
    if (password.length < 6) return 'auth.errPasswordLength';
    final demo = input.toLowerCase() == 'owner@mulkcare.demo';
    _user = UserModel(
      id: demo ? 'usr_1001' : 'usr_demo',
      fullName: demo ? const LocalizedText('أحمد محمد', 'Ahmed Mohamed') : LocalizedText(input.split('@').first, input.split('@').first),
      email: emailLike ? input : '',
      phone: phoneLike ? input : '01X XXX XXXX',
    );
    notifyListeners();
    unawaited(_persist());
    return null;
  }

  String? register({required String name, required String identity, required String password}) {
    if (name.trim().length < 2) return 'auth.errNameShort';
    final error = signIn(identity: identity, password: password);
    if (error != null) return error;
    _user = _user!.copyWith(fullName: LocalizedText(name.trim(), name.trim()));
    notifyListeners();
    unawaited(_persist());
    return null;
  }

  Future<void> signOut() async {
    _user = null;
    notifyListeners();
    await _persist();
  }

  String? updateProfile({required String name, required String email, required String phone}) {
    if (_user == null) return 'profile.saveError';
    if (name.trim().length < 2) return 'auth.errNameShort';
    if (email.trim().isNotEmpty && !(email.contains('@') && email.contains('.'))) return 'auth.errEmailFormat';
    _user = _user!.copyWith(fullName: LocalizedText(name.trim(), name.trim()), email: email.trim(), phone: phone.trim());
    notifyListeners();
    unawaited(_persist());
    return null;
  }

  String? createServiceRequest({
    required String propertyId,
    required String category,
    required String description,
    required DateTime preferredDate,
    required String preferredTime,
    List<String> imagePaths = const [],
  }) {
    if (propertyById(propertyId) == null) return 'services.errProperty';
    if (!{'general', 'plumbing', 'electrical', 'hvac', 'cleaning', 'pest', 'other'}.contains(category)) return 'services.errCategory';
    if (description.trim().length < 10) return 'services.errDescription';
    final today = cairoNow();
    final day = cairoCalendarDate(today.year, today.month, today.day);
    if (preferredDate.isBefore(day)) return 'services.errDate';
    final serial = 10433 + _requests.length - 6;
    final request = ServiceRequestModel(
      id: 'req_$serial',
      reference: 'MC-$serial',
      propertyId: propertyId,
      ownerId: _user?.id ?? 'usr_1001',
      category: category,
      description: LocalizedText(description.trim(), description.trim()),
      images: List.unmodifiable(imagePaths.take(4)),
      status: 'pending',
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      estimatedCost: null,
      finalCost: null,
      createdAt: cairoNow(),
      updates: const [],
    );
    _requests = [request, ..._requests];
    _addNotification(
      title: const LocalizedText('تم استلام طلب الخدمة', 'Service request received'),
      body: LocalizedText('تم تسجيل الطلب ${request.reference} كطلب تجريبي.', 'Request ${request.reference} was saved as a demo request.'),
      href: '/services',
    );
    notifyListeners();
    unawaited(_persist());
    return null;
  }

  static const Map<String, List<String>> legalTransitions = {
    'pending': ['awaiting_approval', 'scheduled', 'cancelled'],
    'awaiting_approval': ['approved', 'cancelled'],
    'approved': ['scheduled', 'cancelled'],
    'scheduled': ['in_progress', 'cancelled'],
    'in_progress': ['completed'],
    'completed': [],
    'cancelled': [],
  };

  bool canTransition(String from, String to) => (legalTransitions[from] ?? const []).contains(to);

  bool transitionRequest(String requestId, String nextStatus) {
    final index = _requests.indexWhere((request) => request.id == requestId);
    if (index < 0 || !canTransition(_requests[index].status, nextStatus)) return false;
    final current = _requests[index];
    final statusLabel = tr('status.$nextStatus');
    final update = RequestUpdate(
      at: cairoNow(),
      text: LocalizedText('تم تحديث حالة الطلب إلى $statusLabel.', 'Request status changed to $statusLabel.'),
    );
    _requests[index] = current.copyWith(status: nextStatus, updates: [...current.updates, update]);
    _addNotification(
      title: const LocalizedText('تحديث طلب الخدمة', 'Service request updated'),
      body: LocalizedText('تم تحديث الطلب ${current.reference}.', 'Request ${current.reference} has been updated.'),
      href: '/services',
    );
    notifyListeners();
    unawaited(_persist());
    return true;
  }

  void requestSubscription(String planId) {
    final property = properties.first;
    final request = SubscriptionModel(id: 'sub_demo_${_subscriptions.length + 1}', propertyId: property.id, planId: planId, status: 'pending', startDate: cairoNow());
    _subscriptions = [..._subscriptions.where((item) => item.propertyId != property.id), request];
    final plan = planById(planId);
    _addNotification(
      title: const LocalizedText('تم تسجيل طلب الباقة', 'Plan request recorded'),
      body: LocalizedText('طلبك التجريبي لاشتراك ${plan == null ? '' : tr(plan.nameKey)} قيد الانتظار، دون دفع إلكتروني.', 'Your demo plan request is pending; no online payment was made.'),
      href: '/subscriptions',
    );
    notifyListeners();
    unawaited(_persist());
  }

  void requestLocalRecommendation(String category) {
    _addNotification(
      title: const LocalizedText('تم تسجيل طلب الترشيح', 'Recommendation request recorded'),
      body: LocalizedText('سجّلنا طلب ترشيح تجريبي لفئة $category. لا يتوفر دليل حي أو حجز.', 'A demo request for $category was recorded. No live directory or booking is available.'),
      href: '/local',
    );
    notifyListeners();
    unawaited(_persist());
  }

  void _addNotification({required LocalizedText title, required LocalizedText body, required String href}) {
    _nextNotification += 1;
    _notifications = [NotificationModel(id: 'ntf_demo_$_nextNotification', title: title, body: body, read: false, createdAt: cairoNow(), href: href), ..._notifications];
  }

  void markNotificationRead(String id) {
    _notifications = _notifications.map((item) => item.id == id ? item.copyWith(read: true) : item).toList();
    notifyListeners();
    unawaited(_persist());
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((item) => item.copyWith(read: true)).toList();
    notifyListeners();
    unawaited(_persist());
  }

  void setNotificationPreference(String key, bool enabled) {
    if (!notificationPreferences.containsKey(key)) return;
    notificationPreferences[key] = enabled;
    notifyListeners();
    unawaited(_persist());
  }

  String assistantReply(String input) {
    final value = input.toLowerCase();
    if (value.contains('تكييف') || value.contains('air') || value.contains('hvac')) return tr('assistant.demo_ac');
    if (value.contains('تنظيف') || value.contains('clean')) return tr('assistant.demo_cleaning');
    if (value.contains('اشتراك') || value.contains('plan') || value.contains('subscription')) return tr('assistant.demo_plan');
    if (value.contains('فحص') || value.contains('inspection') || value.contains('report')) return tr('assistant.demo_report');
    return tr('assistant.demo_default');
  }

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context');
    return scope!.notifier!;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);
}
