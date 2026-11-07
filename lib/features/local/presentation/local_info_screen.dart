import 'package:flutter/material.dart';
import '../../../core/i18n/app_localizations.dart';

class LocalInfoScreen extends StatelessWidget {
  const LocalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('nav.local'))),
      body: const Center(child: Text('Local guide — pharmacies, supermarkets, essentials, places')),
    );
  }
}
