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

  testWidgets('demo login opens dashboard and bottom navigation works at screen bottom', (tester) async {
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

  testWidgets('successful registration also leaves authentication for the app', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final translations = await AppTranslations.load();
    final state = await AppState.create(translations);
    addTearDown(state.dispose);

    await tester.pumpWidget(MulkCareApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.text(state.tr('auth.tabRegister')));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(5));
    await tester.enterText(fields.at(0), 'Demo Owner');
    await tester.enterText(fields.at(1), 'demo.owner@example.test');
    await tester.enterText(fields.at(2), '+201001234567');
    await tester.enterText(fields.at(3), 'demo123');
    await tester.enterText(fields.at(4), 'demo123');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    final registerButton = find.widgetWithText(FilledButton, state.tr('auth.createAccount'));
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(state.isSignedIn, isTrue);
    expect(find.byType(AuthScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
