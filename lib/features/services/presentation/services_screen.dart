import 'package:flutter/material.dart';
import '../../../core/i18n/app_localizations.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('nav.services'))),
      body: const Center(child: Text('Services')),
    );
  }
}
