import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show EnginePhase;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mulkcare/core/format.dart';
import 'package:mulkcare/core/i18n.dart';
import 'package:mulkcare/design/theme.dart';
import 'package:mulkcare/navigation/app_shell.dart';
import 'package:mulkcare/screens/auth_screen.dart';
import 'package:mulkcare/screens/home_screen.dart';
import 'package:mulkcare/screens/inspection_report_screen.dart';
import 'package:mulkcare/screens/not_found_screen.dart';
import 'package:mulkcare/screens/notifications_screen.dart';
import 'package:mulkcare/screens/profile_screen.dart';
import 'package:mulkcare/screens/property_details_screen.dart';
import 'package:mulkcare/screens/services_screen.dart';
import 'package:mulkcare/state/app_state.dart';

const _screens = <({String name, String route, Widget page})>[
  (name: 'authentication', route: '/auth', page: AuthScreen()),
  (name: 'home', route: '/', page: HomeScreen()),
  (name: 'property details', route: '/property/prp_01', page: PropertyDetailsScreen(propertyId: 'prp_01')),
  (name: 'inspection report', route: '/inspection/rep_2041', page: InspectionReportScreen(reportId: 'rep_2041')),
  (name: 'services', route: '/services', page: ServicesScreen()),
  (name: 'profile', route: '/profile', page: ProfileScreen()),
  (name: 'notifications', route: '/notifications', page: NotificationsScreen()),
  (name: 'not found', route: '/unknown-route', page: NotFoundScreen()),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initializeAppDateFormatting);
  // Real fonts so text widths match the device (default test font is far wider).
  setUpAll(() async {
    final loader = FontLoader('Tajawal');
    for (final w in ['400', '500', '700']) {
      loader.addFont(rootBundle.load('assets/fonts/Tajawal-$w.ttf'));
    }
    await loader.load();
  });

  for (final screen in _screens) {
    testWidgets('${screen.name} screen builds without an exception', timeout: const Timeout(Duration(seconds: 40)), (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final state = await AppState.create(await AppTranslations.load());
      expect(state.signIn(identity: 'owner@mulkcare.demo', password: 'demo123'), isNull);
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(size: const Size(390, 844)),
        child: AppScope(
          state: state,
          child: MaterialApp(
            theme: buildTheme(),
            home: screen.route == '/auth'
                ? screen.page
                : AppShell(routeName: screen.route, child: screen.page),
          ),
        ),
      ));
      // Capped: fails fast (5s of animation time) if a screen never settles.
      await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    });
  }
}
