import 'package:flutter/material.dart';

import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.routeName, required this.child});
  final String routeName;
  final Widget child;

  static const _destinations = <({String route, String key, IconData icon})>[
    (route: '/', key: 'nav.home', icon: Icons.home_outlined),
    (route: '/services', key: 'nav.services', icon: Icons.handyman_outlined),
    (route: '/profile', key: 'nav.profile', icon: Icons.person_outline),
  ];

  int get _selectedIndex {
    if (routeName.startsWith('/services')) return 1;
    if (routeName.startsWith('/profile')) return 2;
    return 0;
  }

  String _titleKey() {
    if (routeName.startsWith('/property/')) return 'property.title';
    if (routeName.startsWith('/inspection/')) return 'inspection.title';
    if (routeName.startsWith('/services')) return 'services.title';
    if (routeName.startsWith('/notifications')) return 'notifications.title';
    if (routeName.startsWith('/profile')) return 'profile.title';
    return 'nav.home';
  }

  bool get _isRoot => const {'/', '/services', '/profile'}.contains(routeName);

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final selected = _selectedIndex;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 56,
        leading: _isRoot
            ? const SizedBox(width: 44)
            : IconButton(
                tooltip: state.tr('common.back'),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  }
                },
                icon: Icon(state.isRtl ? Icons.arrow_forward : Icons.arrow_back),
              ),
        title: Text(state.tr(_titleKey()), maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: state.tr('nav.notifications'),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none_outlined),
              if (state.unreadCount > 0)
                PositionedDirectional(end: -1, top: -1, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle))),
            ]),
          ),
          const SizedBox(width: AppSpace.xs),
        ],
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpace.appColumnMax),
        child: Column(children: [
          const DemoBanner(),
          Expanded(child: child),
        ]),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpace.appColumnMax),
          child: NavigationBar(
            selectedIndex: selected,
            onDestinationSelected: (index) => Navigator.of(context).pushNamedAndRemoveUntil(_destinations[index].route, (route) => false),
            destinations: _destinations.map((item) => NavigationDestination(icon: Icon(item.icon), selectedIcon: Icon(item.icon), label: state.tr(item.key))).toList(),
          ),
        ),
      ),
    );
  }
}
