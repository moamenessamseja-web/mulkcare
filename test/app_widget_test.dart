import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mullky/app_state.dart';
import 'package:mullky/main.dart';
import 'package:mullky/models.dart';
import 'package:mullky/strings.dart';

Future<AppState> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final state = AppState(clock: () => DateTime(2026, 11, 1, 12));
  await tester.pumpWidget(MullkyApp(state: state));
  await tester.pumpAndSettle();
  return state;
}

Future<void> login(WidgetTester tester, String email) async {
  await tester.enterText(find.byKey(const Key('email')), email);
  await tester.enterText(find.byKey(const Key('password')), '123456');
  await tester.tap(find.byKey(const Key('submit')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('app starts on login screen in RTL', (tester) async {
    await pumpApp(tester);
    expect(find.byKey(const Key('email')), findsOneWidget);
    final dir = Directionality.of(tester.element(find.byKey(const Key('email'))));
    expect(dir, TextDirection.rtl);
  });

  testWidgets('bad credentials show an Arabic error and stay on login',
      (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byKey(const Key('email')), 'abc');
    await tester.enterText(find.byKey(const Key('password')), '123456');
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pumpAndSettle();
    expect(find.text(Ar.errEmail), findsOneWidget);
    expect(find.byKey(const Key('email')), findsOneWidget);
  });

  testWidgets('owner sees units, no admin tab; can send a service request',
      (tester) async {
    final state = await pumpApp(tester);
    await login(tester, 'owner@example.com');
    expect(find.text('فيلا النخيل'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.text('فيلا النخيل'));
    await tester.pumpAndSettle();
    expect(find.text(Ar.noRequests), findsOneWidget);

    await tester.tap(find.byKey(const Key('new-request')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('type-pestControl')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('notes')), 'نمل في الحديقة');
    await tester.tap(find.byKey(const Key('submit-request')));
    await tester.pumpAndSettle();

    expect(find.text('نمل في الحديقة'), findsOneWidget);
    final created = state.requestsFor('u2').single;
    expect(created.type, ServiceType.pestControl);
    expect(created.status, RequestStatus.pending);
  });

  testWidgets('admin can change status and add an invoice', (tester) async {
    final state = await pumpApp(tester);
    await login(tester, 'admin@example.com');
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.admin_panel_settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('صيانة · شاليه المارينا'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('status-done')));
    await tester.pumpAndSettle();
    expect(
        state.allRequests().firstWhere((r) => r.id == 'r2').status,
        RequestStatus.done);

    await tester.enterText(find.byKey(const Key('invoice-amount')), '500');
    await tester.tap(find.byKey(const Key('add-invoice')));
    await tester.pumpAndSettle();
    expect(state.invoicesForRequest('r2').single.amount, 500);
  });
}
