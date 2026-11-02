import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mulkcare/core/format.dart';
import 'package:mulkcare/core/i18n.dart';
import 'package:mulkcare/design/theme.dart';
import 'package:mulkcare/navigation/app_shell.dart';
import 'package:mulkcare/screens/assistant_screen.dart';
import 'package:mulkcare/screens/auth_screen.dart';
import 'package:mulkcare/screens/home_screen.dart';
import 'package:mulkcare/screens/inspection_report_screen.dart';
import 'package:mulkcare/screens/local_info_screen.dart';
import 'package:mulkcare/screens/not_found_screen.dart';
import 'package:mulkcare/screens/notifications_screen.dart';
import 'package:mulkcare/screens/profile_screen.dart';
import 'package:mulkcare/screens/property_details_screen.dart';
import 'package:mulkcare/screens/services_screen.dart';
import 'package:mulkcare/screens/subscriptions_screen.dart';
import 'package:mulkcare/state/app_state.dart';

const _screens = <({String name, String route, Widget page})>[
  (name: 'authentication', route: '/auth', page: AuthScreen()),
  (name: 'home', route: '/', page: HomeScreen()),
  (name: 'property details', route: '/property/prp_01', page: PropertyDetailsScreen(propertyId: 'prp_01')),
  (name: 'inspection report', route: '/inspection/rep_2041', page: InspectionReportScreen(reportId: 'rep_2041')),
  (name: 'services', route: '/services', page: ServicesScreen()),
  (name: 'local guide', route: '/local', page: LocalInfoScreen()),
  (name: 'assistant', route: '/assistant', page: AssistantScreen()),
  (name: 'subscriptions', route: '/subscriptions', page: SubscriptionsScreen()),
  (name: 'profile', route: '/profile', page: ProfileScreen()),
  (name: 'notifications', route: '/notifications', page: NotificationsScreen()),
  (name: 'not found', route: '/unknown-route', page: NotFoundScreen()),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initializeAppDateFormatting);

  for (final screen in _screens) {
    testWidgets('${screen.name} screen builds without an exception', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final state = await AppState.create(AppTranslations(ar: const {}, en: const {}));
      expect(state.signIn(identity: 'owner@mulkcare.demo', password: 'demo123'), isNull);
      await tester.pumpWidget(AppScope(
        state: state,
        child: MaterialApp(
          theme: buildTheme(),
          home: screen.route == '/auth'
              ? screen.page
              : AppShell(routeName: screen.route, child: screen.page),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    });
  }
}
