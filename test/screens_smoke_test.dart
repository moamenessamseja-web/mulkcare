import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mulkcare/core/format.dart';
import 'package:mulkcare/core/i18n.dart';
import 'package:mulkcare/main.dart';
import 'package:mulkcare/state/app_state.dart';

/// Every screen is opened through the REAL app and its REAL route table
/// (same path a user takes), at phone size, with the real font and translations.
const _routes = <({String name, String route})>[
  (name: 'authentication', route: '/auth'),
  (name: 'home', route: '/'),
  (name: 'property details', route: '/property/prp_01'),
  (name: 'inspection report', route: '/inspection/rep_2041'),
  (name: 'services', route: '/services'),
  (name: 'profile', route: '/profile'),
  (name: 'notifications', route: '/notifications'),
  (name: 'not found', route: '/unknown-route'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initializeAppDateFormatting);
  // Real fonts so text widths match the device (the default test font is far wider).
  setUpAll(() async {
    final loader = FontLoader('Tajawal');
    for (final w in ['400', '500', '700']) {
      loader.addFont(rootBundle.load('assets/fonts/Tajawal-$w.ttf'));
    }
    await loader.load();
  });

  for (final screen in _routes) {
    testWidgets('${screen.name} screen builds without an exception',
        timeout: const Timeout(Duration(seconds: 60)), (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final state = await AppState.create(await AppTranslations.load());
      addTearDown(state.dispose);
      expect(state.signIn(identity: 'owner@mulkcare.demo', password: 'demo123'), isNull);

      await tester.pumpWidget(MulkCareApp(state: state));
      // Capped: fails fast (5s of animation time) if a screen never settles.
      await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 5));
      if (screen.route != '/') {
        final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
        nav.pushNamed(screen.route);
        await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 5));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
