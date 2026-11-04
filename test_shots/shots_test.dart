// ignore_for_file: invalid_use_of_visible_for_testing_member
// Visual evidence harness (NOT part of `flutter test`): renders screens at phone size
// with the real Tajawal font and writes PNGs to build/shots/. CI publishes them.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mulkcare/core/i18n.dart';
import 'package:mulkcare/main.dart';
import 'package:mulkcare/state/app_state.dart';

Future<void> _loadFont() async {
  final loader = FontLoader('Tajawal');
  for (final w in ['400', '500', '700']) {
    loader.addFont(rootBundle.load('assets/fonts/Tajawal-$w.ttf'));
  }
  await loader.load();
  try {
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  } catch (e) {
    // ignore: avoid_print
    print('ICONFONT: could not load MaterialIcons: $e');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture screens', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await _loadFont();
    tester.view.physicalSize = const Size(780, 1688); // 390x844 @2x
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final translations = await AppTranslations.load();
    final state = await AppState.create(translations);
    addTearDown(state.dispose);
    final key = GlobalKey();
    Directory('build/shots').createSync(recursive: true);

    Future<void> shot(String name) async {
      await tester.pumpAndSettle();
      final ex = tester.takeException();
      // ignore: avoid_print
      if (ex != null) print('EXCEPTION before $name: $ex');
      await tester.runAsync(() async {
        final b = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final img = await b.toImage(pixelRatio: 1);
        final data = await img.toByteData(format: ui.ImageByteFormat.png);
        File('build/shots/$name.png').writeAsBytesSync(data!.buffer.asUint8List());
      });
    }

    await tester.pumpWidget(RepaintBoundary(key: key, child: MulkCareApp(state: state)));
    await tester.runAsync(() async {
      final ctx = tester.element(find.byType(MaterialApp));
      for (final f in Directory('assets/images').listSync()) {
        if (f is File) await precacheImage(AssetImage(f.path.replaceAll('\\', '/')), ctx);
      }
    });
    await shot('01-auth');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'owner@mulkcare.demo');
    await tester.enterText(fields.at(1), 'demo123');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    final loginButton = find.widgetWithText(FilledButton, state.tr('auth.login'));
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    await shot('02-home');

    for (final item in [('nav.services', '03-services'), ('nav.profile', '04-profile')]) {
      await tester.tap(find.text(state.tr(item.$1)).last);
      await shot(item.$2);
    }

    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    nav.pushNamed('/property/${state.properties.first.id}');
    await shot('07-property');
    nav.pushNamed('/inspection/${state.inspectionReports.first.id}');
    await shot('08-inspection');
    nav.pushNamed('/notifications');
    await shot('09-notifications');
  });
}
