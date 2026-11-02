import 'package:flutter/material.dart';

import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginIdentity = TextEditingController();
  final _loginPassword = TextEditingController();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _registerPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _isLogin = true;
  bool _showPassword = false;
  bool _pending = false;
  String? _formError;
  String? _notice;
  final Map<String, String?> _errors = {};

  @override
  void dispose() {
    _loginIdentity.dispose();
    _loginPassword.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _registerPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _switchTab(bool login) {
    setState(() {
      _isLogin = login;
      _errors.clear();
      _formError = null;
      _notice = null;
    });
  }

  String? _checkIdentity(String value) {
    if (value.trim().isEmpty) return 'auth.errRequired';
    final input = value.trim();
    final emailLike = input.contains('@') && input.contains('.');
    final phoneLike = input.replaceAll(RegExp(r'[^0-9+]'), '').length >= 8;
    return emailLike || phoneLike ? null : 'auth.errEmail';
  }

  String? _checkEmail(String value) {
    if (value.trim().isEmpty) return 'auth.errRequired';
    return _checkIdentity(value) == null ? null : 'auth.errEmailFormat';
  }

  String? _checkPhone(String value) {
    if (value.trim().isEmpty) return 'auth.errRequired';
    return _checkIdentity(value) == null ? null : 'auth.errPhone';
  }

  String? _checkPassword(String value) {
    if (value.isEmpty) return 'auth.errRequired';
    return value.length >= 6 ? null : 'auth.errPasswordLength';
  }

  String? _checkName(String value) {
    if (value.trim().isEmpty) return 'auth.errRequired';
    return value.trim().length >= 2 ? null : 'auth.errNameShort';
  }

  String? _checkConfirmation(String password, String confirmation) {
    if (confirmation.isEmpty) return 'auth.errRequired';
    return password == confirmation ? null : 'auth.errPasswordMatch';
  }

  void _validateOnBlur(String field) {
    if (!mounted) return;
    String? error;
    if (_isLogin) {
      if (field == 'identity' && _loginIdentity.text.isNotEmpty) {
        error = _checkIdentity(_loginIdentity.text);
      } else if (field == 'password' && _loginPassword.text.isNotEmpty) {
        error = _checkPassword(_loginPassword.text);
      }
    } else {
      switch (field) {
        case 'fullName':
          if (_fullName.text.isNotEmpty) error = _checkName(_fullName.text);
          break;
        case 'email':
          if (_email.text.isNotEmpty) error = _checkEmail(_email.text);
          break;
        case 'phone':
          if (_phone.text.isNotEmpty) error = _checkPhone(_phone.text);
          break;
        case 'password':
          if (_registerPassword.text.isNotEmpty) {
            error = _checkPassword(_registerPassword.text);
          }
          break;
        case 'confirmPassword':
          if (_confirmPassword.text.isNotEmpty) {
            error = _checkConfirmation(
              _registerPassword.text,
              _confirmPassword.text,
            );
          }
          break;
      }
    }
    setState(() => _errors[field] = error);
  }

  void _onFieldChanged(String field) {
    if (_errors[field] != null) setState(() => _errors[field] = null);
  }

  Future<void> _submitLogin() async {
    final errors = <String, String?>{
      'identity': _checkIdentity(_loginIdentity.text),
      'password': _checkPassword(_loginPassword.text),
    };
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
      _formError = errors.values.any((error) => error != null)
          ? 'auth.errRequired'
          : null;
      _notice = null;
    });
    if (errors.values.any((error) => error != null)) return;

    setState(() => _pending = true);
    final state = AppState.of(context);
    final result = state.signIn(
      identity: _loginIdentity.text.trim(),
      password: _loginPassword.text,
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _formError = result;
        _pending = false;
      });
      return;
    }
    _showMessage(state.tr('auth.successLogin'));
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  Future<void> _submitRegistration() async {
    final errors = <String, String?>{
      'fullName': _checkName(_fullName.text),
      'email': _checkEmail(_email.text),
      'phone': _checkPhone(_phone.text),
      'password': _checkPassword(_registerPassword.text),
      'confirmPassword': _checkConfirmation(
        _registerPassword.text,
        _confirmPassword.text,
      ),
    };
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
      _formError = errors.values.any((error) => error != null)
          ? 'auth.errRequired'
          : null;
      _notice = null;
    });
    if (errors.values.any((error) => error != null)) return;

    setState(() => _pending = true);
    final state = AppState.of(context);
    final result = state.register(
      name: _fullName.text.trim(),
      identity: _email.text.trim(),
      password: _registerPassword.text,
    );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _formError = result;
        _pending = false;
      });
      return;
    }
    _showMessage(state.tr('auth.registerNotice'));
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _field({
    required AppState state,
    required String field,
    required String labelKey,
    String? hintKey,
    required TextEditingController controller,
    bool ltr = false,
    bool password = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    final errorKey = _errors[field];
    final direction = ltr ? TextDirection.ltr : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.tr(labelKey),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpace.xxs),
          Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) _validateOnBlur(field);
            },
            child: TextField(
              controller: controller,
              obscureText: password && !_showPassword,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              textDirection: direction,
              textAlign: ltr
                  ? TextAlign.left
                  : state.isRtl
                      ? TextAlign.right
                      : TextAlign.left,
              autocorrect: !password && !ltr,
              enableSuggestions: !password,
              onChanged: (_) => _onFieldChanged(field),
              onSubmitted: (_) {
                if (field == 'password' && _isLogin) _submitLogin();
                if (field == 'confirmPassword' && !_isLogin) {
                  _submitRegistration();
                }
              },
              decoration: InputDecoration(
                hintText: hintKey == null ? null : state.tr(hintKey),
                errorText: errorKey == null ? null : state.tr(errorKey),
                errorMaxLines: 2,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.md,
                  vertical: AppSpace.sm,
                ),
                suffixIcon: password
                    ? IconButton(
                        tooltip: state.tr(
                          _showPassword
                              ? 'auth.hidePassword'
                              : 'auth.showPassword',
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryStrong,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/auth_hurghada_terrace.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x26063A55),
                  Color(0x4D063A55),
                  Color(0xA6063A55),
                ],
                stops: [0, 0.46, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpace.md,
                    AppSpace.sm,
                    AppSpace.md,
                    AppSpace.xs,
                  ),
                  child: Align(
                    alignment: state.isRtl
                        ? AlignmentDirectional.topStart
                        : AlignmentDirectional.topEnd,
                    child: OutlinedButton.icon(
                      onPressed: () => state.setLanguage(
                        state.language == 'ar' ? 'en' : 'ar',
                      ),
                      icon: const Icon(Icons.language, size: 18),
                      label: Text(state.tr('meta.otherLangLabel')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onBrand,
                        side: const BorderSide(color: Color(0xBFFFFFFF)),
                        backgroundColor: const Color(0x26072F47),
                        minimumSize: const Size(44, AppSpace.touchMin),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        AppSpace.md,
                        AppSpace.xs,
                        AppSpace.md,
                        AppSpace.md,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: (constraints.maxHeight - AppSpace.md)
                              .clamp(0.0, double.infinity)
                              .toDouble(),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: _buildSheet(state, theme),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheet(AppState state, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
        boxShadow: raisedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: AppColors.onBrand,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.tr('meta.appName'),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      state.tr('meta.tagline'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Container(
            padding: const EdgeInsets.all(AppSpace.xxs),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _tabButton(
                    state: state,
                    label: state.tr('auth.tabLogin'),
                    selected: _isLogin,
                    onPressed: () => _switchTab(true),
                  ),
                ),
                Expanded(
                  child: _tabButton(
                    state: state,
                    label: state.tr('auth.tabRegister'),
                    selected: !_isLogin,
                    onPressed: () => _switchTab(false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            state.tr('auth.intro'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          if (_formError != null) ...[
            InlineNotice(
              title: state.tr('auth.title'),
              body: state.tr(_formError!),
              icon: Icons.info_outline,
              tone: NoticeTone.danger,
            ),
            const SizedBox(height: AppSpace.md),
          ],
          if (_notice != null) ...[
            InlineNotice(
              title: state.tr('auth.title'),
              body: _notice!,
              icon: Icons.info_outline,
              tone: NoticeTone.warning,
            ),
            const SizedBox(height: AppSpace.md),
          ],
          if (_isLogin) _buildLoginForm(state) else _buildRegisterForm(state),
          const SizedBox(height: AppSpace.sm),
          InlineNotice(
            title: state.tr('auth.devModeTitle'),
            body: '${state.tr('auth.devModeBody')}\n${state.tr('auth.devCredential')}',
            icon: Icons.info_outline,
            tone: NoticeTone.warning,
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            state.tr('auth.credentialsNote'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required AppState state,
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      button: true,
      selected: selected,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor:
              selected ? AppColors.primary : AppColors.onSurfaceMuted,
          backgroundColor: selected ? AppColors.surface : Colors.transparent,
          minimumSize: const Size(0, AppSpace.touchMin),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildLoginForm(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field(
          state: state,
          field: 'identity',
          labelKey: 'auth.emailOrPhone',
          hintKey: 'auth.emailOrPhonePh',
          controller: _loginIdentity,
          ltr: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        _field(
          state: state,
          field: 'password',
          labelKey: 'auth.password',
          hintKey: 'auth.passwordPh',
          controller: _loginPassword,
          password: true,
          ltr: true,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: _pending ? null : _submitLogin,
            child: _pending
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onBrand,
                        ),
                      ),
                      const SizedBox(width: AppSpace.xs),
                      Flexible(child: Text(state.tr('auth.loggingIn'))),
                    ],
                  )
                : Text(state.tr('auth.login')),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: TextButton(
            onPressed: () {
              final message = state.tr('auth.forgotNotice');
              setState(() => _notice = message);
              _showMessage(message);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryStrong,
              minimumSize: const Size(44, AppSpace.touchMin),
            ),
            child: Text(state.tr('auth.forgot')),
          ),
        ),
        OutlinedButton(
          onPressed: _pending ? null : () => _switchTab(false),
          child: Text(state.tr('auth.createAccount')),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field(
          state: state,
          field: 'fullName',
          labelKey: 'auth.fullName',
          hintKey: 'auth.fullNamePh',
          controller: _fullName,
          textInputAction: TextInputAction.next,
        ),
        _field(
          state: state,
          field: 'email',
          labelKey: 'auth.email',
          hintKey: 'auth.emailPh',
          controller: _email,
          ltr: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        _field(
          state: state,
          field: 'phone',
          labelKey: 'auth.phone',
          hintKey: 'auth.phonePh',
          controller: _phone,
          ltr: true,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        _field(
          state: state,
          field: 'password',
          labelKey: 'auth.password',
          hintKey: 'auth.passwordPh',
          controller: _registerPassword,
          password: true,
          ltr: true,
          textInputAction: TextInputAction.next,
        ),
        _field(
          state: state,
          field: 'confirmPassword',
          labelKey: 'auth.confirmPassword',
          controller: _confirmPassword,
          password: true,
          ltr: true,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: _pending ? null : _submitRegistration,
            child: _pending
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onBrand,
                        ),
                      ),
                      const SizedBox(width: AppSpace.xs),
                      Flexible(child: Text(state.tr('auth.creatingAccount'))),
                    ],
                  )
                : Text(state.tr('auth.createAccount')),
          ),
        ),
      ],
    );
  }
}
