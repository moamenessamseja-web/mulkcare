import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mulkcare/main.dart';
import 'package:mulkcare/navigation/app_shell.dart';
import 'package:mulkcare/screens/auth_screen.dart';
import 'package:mulkcare/screens/home_screen.dart';
import 'package:mulkcare/screens/services_screen.dart';
import 'package:mulkcare/state/app_state.dart';
import 'package:mulkcare/core/i18n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('demo login opens dashboard and bottom navigation works at screen bottom', timeout: const Timeout(Duration(seconds: 60)), (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final translations = await AppTranslations.load();
    final state = await AppState.create(translations);
    addTearDown(state.dispose);

    await tester.pumpWidget(MulkCareApp(state: state));
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'owner@mulkcare.demo');
    await tester.enterText(fields.at(1), 'demo123');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(FilledButton, state.tr('auth.login'));
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsNothing);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text(state.tr('home.subtitle')), findsOneWidget);

    final navigation = find.byType(NavigationBar);
    expect(navigation, findsOneWidget);
    final navigationRect = tester.getRect(navigation);
    expect(navigationRect.top, greaterThan(844 * 0.75));
    expect(navigationRect.bottom, closeTo(844, 8));

    await tester.tap(find.text(state.tr('nav.services')));
    await tester.pumpAndSettle();
    expect(find.byType(ServicesScreen), findsOneWidget);
    expect(tester.widget<NavigationBar>(navigation).selectedIndex, 1);
  });
}
