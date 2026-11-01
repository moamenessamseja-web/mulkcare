import 'package:flutter/material.dart';

import '../app_state.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _registerMode = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final state = AppScope.of(context);
    final err = _registerMode
        ? state.register(
            name: _name.text, email: _email.text, password: _password.text)
        : state.signIn(email: _email.text, password: _password.text);
    if (err != null) setState(() => _error = err);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/auth-terrace.jpg',
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: AppColors.primary),
          ),
          Container(color: AppColors.scrim),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpace.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Ar.appName,
                        style: AppText.display
                            .copyWith(color: AppColors.onBrand)),
                    Text(Ar.tagline,
                        style: AppText.body
                            .copyWith(color: AppColors.onBrand)),
                    const SizedBox(height: AppSpace.sm),
                    const Chip28(
                      text: Ar.demoBadge,
                      background: AppColors.accentTint,
                      foreground: AppColors.accentStrong,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl)),
                boxShadow: raisedShadow,
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpace.screen,
                AppSpace.lg,
                AppSpace.screen,
                AppSpace.lg + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_registerMode ? Ar.register : Ar.signIn,
                        style: AppText.h2),
                    const SizedBox(height: AppSpace.md),
                    if (_registerMode) ...[
                      TextField(
                        key: const Key('name'),
                        controller: _name,
                        decoration:
                            const InputDecoration(labelText: Ar.fullName),
                      ),
                      const SizedBox(height: AppSpace.sm),
                    ],
                    TextField(
                      key: const Key('email'),
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(labelText: Ar.email),
                    ),
                    const SizedBox(height: AppSpace.sm),
                    TextField(
                      key: const Key('password'),
                      controller: _password,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      decoration:
                          const InputDecoration(labelText: Ar.password),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: AppSpace.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpace.sm),
                        decoration: BoxDecoration(
                          color: AppColors.dangerTint,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(_error!,
                            key: const Key('login-error'),
                            style: AppText.label
                                .copyWith(color: AppColors.danger)),
                      ),
                    ],
                    const SizedBox(height: AppSpace.md),
                    FilledButton(
                      key: const Key('submit'),
                      onPressed: _submit,
                      child: Text(_registerMode ? Ar.register : Ar.signIn),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _registerMode = !_registerMode;
                        _error = null;
                      }),
                      child: Text(
                          _registerMode ? Ar.haveAccount : Ar.noAccount,
                          style: AppText.label
                              .copyWith(color: AppColors.secondaryStrong)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
