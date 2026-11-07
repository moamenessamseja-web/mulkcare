import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/store/app_store.dart';
import '../../../core/i18n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    final store = context.watch<AppStore>();
    return Scaffold(
      appBar: AppBar(title: Text(t('nav.profile'))),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t('auth.title')),
            onTap: () async {
              await store.signOut();
              if (context.mounted) context.go('/auth');
            },
          ),
        ],
      ),
    );
  }
}
