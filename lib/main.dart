import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/format.dart';
import 'core/i18n.dart';
import 'design/theme.dart';
import 'navigation/app_shell.dart';
import 'screens/assistant_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/inspection_report_screen.dart';
import 'screens/local_info_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/property_details_screen.dart';
import 'screens/services_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeAppTimeZone();
  final translations = await AppTranslations.load();
  final state = await AppState.create(translations);
  runApp(MulkCareApp(state: state));
}

class MulkCareApp extends StatelessWidget {
  const MulkCareApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => AppScope(
        state: state,
        child: AnimatedBuilder(
          animation: state,
          builder: (context, _) => MaterialApp(
            title: 'MulkCare',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(),
            locale: Locale(state.language),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: state.isSignedIn
                ? const _RouteScreen(routeName: '/', child: HomeScreen())
                : const AuthScreen(),
            onGenerateRoute: (settings) => _route(state, settings.name ?? '/'),
            ),
          ),
        );
}

Route<dynamic> _route(AppState state, String routeName) {
  if (routeName == '/auth') return MaterialPageRoute<void>(builder: (_) => const AuthScreen(), settings: RouteSettings(name: routeName));
  if (!state.isSignedIn) return MaterialPageRoute<void>(builder: (_) => const AuthScreen(), settings: const RouteSettings(name: '/auth'));

  Widget page;
  if (routeName == '/' || routeName == '/property') {
    page = const HomeScreen();
  } else if (routeName.startsWith('/property/')) {
    page = PropertyDetailsScreen(propertyId: routeName.split('/').last);
  } else if (routeName.startsWith('/inspection/')) {
    page = InspectionReportScreen(reportId: routeName.split('/').last);
  } else if (routeName == '/services') {
    page = const ServicesScreen();
  } else if (routeName == '/local') {
    page = const LocalInfoScreen();
  } else if (routeName == '/assistant') {
    page = const AssistantScreen();
  } else if (routeName == '/subscriptions') {
    page = const SubscriptionsScreen();
  } else if (routeName == '/profile') {
    page = const ProfileScreen();
  } else if (routeName == '/notifications') {
    page = const NotificationsScreen();
  } else {
    page = const NotFoundScreen();
  }
  return MaterialPageRoute<void>(
    builder: (_) => _RouteScreen(routeName: routeName, child: page),
    settings: RouteSettings(name: routeName),
  );
}

class _RouteScreen extends StatelessWidget {
  const _RouteScreen({required this.routeName, required this.child});
  final String routeName;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppShell(routeName: routeName, child: child);
}
