import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mulkcare/core/format.dart';
import 'package:mulkcare/core/i18n.dart';
import 'package:mulkcare/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppState state;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    state = await AppState.create(AppTranslations(
      ar: const {'nav': {'home': 'الرئيسية'}},
      en: const {'nav': {'home': 'Home'}},
    ));
  });

  test('demo app starts signed out and exposes the full sample bundle', () {
    expect(tz.local.name, 'Africa/Cairo');
    expect(state.isSignedIn, isFalse);
    expect(state.properties, hasLength(3));
    expect(state.serviceRequests, hasLength(6));
    expect(state.inspectionReports, hasLength(2));
    expect(state.invoices, hasLength(3));
  });

  test('demo sign-in accepts a valid identity and never persists a password', () async {
    expect(state.signIn(identity: 'owner@mulkcare.demo', password: 'demo123'), isNull);
    expect(state.isSignedIn, isTrue);
    expect(state.user?.id, 'usr_1001');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('mulkcare.user'), isNot(contains('demo123')));
  });

  test('service request status changes enforce the allowed transition graph', () {
    expect(state.transitionRequest('req_10432', 'approved'), isTrue);
    expect(state.serviceRequests.firstWhere((item) => item.id == 'req_10432').status, 'approved');
    expect(state.transitionRequest('req_10432', 'completed'), isFalse);
  });

  test('service request validates required description and saves valid local requests', () {
    final today = cairoNow();
    final date = cairoCalendarDate(today.year, today.month, today.day);
    final tooShort = state.createServiceRequest(
      propertyId: 'prp_01', category: 'hvac', description: 'short',
      preferredDate: date, preferredTime: '10:00',
    );
    expect(tooShort, 'services.errDescription');
    final result = state.createServiceRequest(
      propertyId: 'prp_01', category: 'hvac',
      description: 'The bedroom air conditioner needs service.',
      preferredDate: date, preferredTime: '10:00',
    );
    expect(result, isNull);
    expect(state.serviceRequests, hasLength(7));
    expect(state.serviceRequests.first.status, 'pending');
  });

  test('calendar-day addition preserves local wall time across timezone transitions', () {
    final before = cairoCalendarDate(2026, 10, 29, 12);
    final after = addCairoCalendarDays(before, 1);
    expect(after.year, 2026);
    expect(after.month, 10);
    expect(after.day, 30);
    expect(after.hour, 12);
  });

  test('language preference is persisted and reflected in translation lookup', () async {
    await state.setLanguage('en');
    expect(state.language, 'en');
    expect(state.tr('nav.home'), 'Home');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('mulkcare.language'), 'en');
  });
}
