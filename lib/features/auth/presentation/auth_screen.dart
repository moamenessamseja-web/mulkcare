import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/store/app_store.dart';
import '../../../core/i18n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t('appName'), style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              TextField(controller: _email, decoration: InputDecoration(labelText: t('auth.emailOrPhone'))),
              const SizedBox(height: 16),
              TextField(controller: _password, obscureText: true, decoration: InputDecoration(labelText: t('auth.password'))),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _loading ? null : () async {
                  setState(() => _loading = true);
                  await context.read<AppStore>().signIn(_email.text);
                  if (context.mounted) context.go('/');
                },
                child: Text(t('auth.login')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
