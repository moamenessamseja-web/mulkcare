import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/i18n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('nav.home'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.home),
              title: Text(t('nav.home')),
              onTap: () => context.go('/property/prp_01'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.build),
              title: Text(t('nav.services')),
              onTap: () => context.go('/services'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.explore),
              title: Text(t('nav.local')),
              onTap: () => context.go('/local'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: t('nav.home')),
          NavigationDestination(icon: const Icon(Icons.build), label: t('nav.services')),
          NavigationDestination(icon: const Icon(Icons.explore), label: t('nav.local')),
          NavigationDestination(icon: const Icon(Icons.person), label: t('nav.profile')),
        ],
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/'); break;
            case 1: context.go('/services'); break;
            case 2: context.go('/local'); break;
            case 3: context.go('/profile'); break;
          }
        },
      ),
    );
  }
}
