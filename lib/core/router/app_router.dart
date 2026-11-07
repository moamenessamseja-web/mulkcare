import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/property/presentation/property_details_screen.dart';
import '../../features/inspection/presentation/inspection_report_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/local/presentation/local_info_screen.dart';
import '../../features/subscriptions/presentation/subscriptions_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../store/app_store.dart';

GoRouter buildRouter(AppStore store) {
  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final isAuth = state.matchedLocation == '/auth';
      final signedIn = store.isAuthenticated;
      if (!signedIn && !isAuth) return '/auth';
      if (signedIn && isAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/property/:id', builder: (_, s) => PropertyDetailsScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/inspection/:id', builder: (_, s) => InspectionReportScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/services', builder: (_, __) => const ServicesScreen()),
      GoRoute(path: '/local', builder: (_, __) => const LocalInfoScreen()),
      GoRoute(path: '/subscriptions', builder: (_, __) => const SubscriptionsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
    ],
  );
}
