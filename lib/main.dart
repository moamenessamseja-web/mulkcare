import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_state.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'strings.dart';
import 'theme.dart';

void main() {
  // Startup must never be silent: show a readable error instead of a black screen.
  try {
    runApp(MullkyApp(state: AppState()));
  } catch (e, st) {
    runApp(StartupErrorApp(error: e, stack: st));
  }
}

class MullkyApp extends StatelessWidget {
  final AppState state;
  const MullkyApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: MaterialApp(
        title: Ar.appName,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return state.isSignedIn ? const HomeScreen() : const LoginScreen();
  }
}

class StartupErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stack;
  const StartupErrorApp({super.key, required this.error, required this.stack});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.screen),
            child: SingleChildScrollView(
              child: Text('${Ar.startupError}\n\n$error\n\n$stack',
                  style: AppText.body),
            ),
          ),
        ),
      ),
    );
  }
}
