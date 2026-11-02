import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  bool _initialized = false;
  bool _saving = false;
  String _savedName = '';
  String _savedEmail = '';
  String _savedPhone = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final user = AppState.of(context).user;
    _name.text = user?.fullName.value(AppState.of(context).language) ?? '';
    _email.text = user?.email ?? '';
    _phone.text = user?.phone ?? '';
    _rememberSaved();
    _initialized = true;
  }

  void _rememberSaved() {
    _savedName = _name.text;
    _savedEmail = _email.text;
    _savedPhone = _phone.text;
  }

  bool get _dirty => _name.text != _savedName || _email.text != _savedEmail || _phone.text != _savedPhone;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save(AppState state) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final error = state.updateProfile(name: _name.text, email: _email.text, phone: _phone.text);
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (error == null) _rememberSaved();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.tr(error ?? 'profile.saveSuccess'))));
  }

  Future<void> _signOut(AppState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(state.tr('profile.logoutConfirmTitle')),
        content: Text(state.tr('profile.logoutConfirmBody')),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(state.tr('common.cancel'))),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(state.tr('profile.logout'))),
        ],
      ),
    );
    if (confirmed != true) return;
    await state.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  Widget _groupTile({required String title, required int count, required Widget child, IconData icon = Icons.folder_outlined}) => Card(
        margin: const EdgeInsets.only(bottom: AppSpace.sm),
        child: ExpansionTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.xxs), decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(AppRadius.full)), child: Text('$count')),
            const SizedBox(width: AppSpace.xs),
            const Icon(Icons.expand_more),
          ]),
          children: [Padding(padding: const EdgeInsets.fromLTRB(AppSpace.md, 0, AppSpace.md, AppSpace.md), child: child)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final user = state.user;
    final properties = state.properties;
    final requests = state.serviceRequests;
    final invoices = state.invoices;
    final initials = (user?.fullName.value(state.language).trim().isNotEmpty ?? false) ? user!.fullName.value(state.language).trim().substring(0, 1) : '?';

    return ListView(padding: const EdgeInsets.fromLTRB(AppSpace.screen, AppSpace.md, AppSpace.screen, AppSpace.xl), children: [
      SurfaceCard(child: Row(children: [
        CircleAvatar(radius: 30, backgroundColor: AppColors.primaryTint, child: Text(initials, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary))),
        const SizedBox(width: AppSpace.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user?.fullName.value(state.language) ?? '—', style: Theme.of(context).textTheme.titleLarge),
          Text(user?.email.isNotEmpty == true ? user!.email : '—', textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
          if (user?.phone.isNotEmpty == true) Text(user!.phone, textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
        ])),
        IconButton(tooltip: state.tr('profile.changePhoto'), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.tr('profile.photoNotice')))), icon: const Icon(Icons.camera_alt_outlined)),
      ])),
      const SizedBox(height: AppSpace.md),
      if (_dirty) ...[
        InlineNotice(title: state.tr('profile.unsavedWarning'), body: state.tr('profile.unsavedWarning'), tone: NoticeTone.info, icon: Icons.edit_note),
        Align(alignment: AlignmentDirectional.centerEnd, child: TextButton(onPressed: () => setState(() { _name.text = _savedName; _email.text = _savedEmail; _phone.text = _savedPhone; }), child: Text(state.tr('profile.discard')))),
      ],
      SectionHeading(state.tr('profile.editTitle')),
      SurfaceCard(child: Form(key: _formKey, child: Column(children: [
        TextFormField(controller: _name, textDirection: state.isRtl ? TextDirection.rtl : TextDirection.ltr, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: state.tr('profile.fullName'), prefixIcon: const Icon(Icons.person_outline)), validator: (value) => (value?.trim().length ?? 0) < 2 ? state.tr('auth.errNameShort') : null, onChanged: (_) => setState(() {})),
        const SizedBox(height: AppSpace.sm),
        TextFormField(controller: _email, textDirection: TextDirection.ltr, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: state.tr('profile.email'), prefixIcon: const Icon(Icons.email_outlined)), validator: (value) { final v = value?.trim() ?? ''; return v.isNotEmpty && !(v.contains('@') && v.contains('.')) ? state.tr('auth.errEmailFormat') : null; }, onChanged: (_) => setState(() {})),
        const SizedBox(height: AppSpace.sm),
        TextFormField(controller: _phone, textDirection: TextDirection.ltr, keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, decoration: InputDecoration(labelText: state.tr('profile.phone'), prefixIcon: const Icon(Icons.phone_outlined)), onChanged: (_) => setState(() {})),
        const SizedBox(height: AppSpace.md),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: !_dirty || _saving ? null : () => _save(state), icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined), label: Text(state.tr(_saving ? 'common.saving' : 'profile.saveChanges')))),
      ]))),
      const SizedBox(height: AppSpace.lg),
      SectionHeading(state.tr('profile.groupLanguage')),
      SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(state.tr('profile.language'), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpace.sm),
        SegmentedButton<String>(segments: const [ButtonSegment(value: 'ar', label: Text('العربية'), icon: Icon(Icons.language)), ButtonSegment(value: 'en', label: Text('English'), icon: Icon(Icons.language))], selected: {state.language}, onSelectionChanged: (selection) { state.setLanguage(selection.first); }),
      ])),
      const SizedBox(height: AppSpace.lg),
      SectionHeading(state.tr('profile.groupNotifications')),
      SurfaceCard(padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xs), child: Column(children: [
        for (final key in const ['visits', 'maintenance', 'invoices', 'marketing'])
          SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: Text(state.tr('profile.notifications.$key')), value: state.notificationPreferences[key] ?? false, onChanged: (value) => state.setNotificationPreference(key, value)),
        Align(alignment: AlignmentDirectional.centerStart, child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpace.md), child: Text(state.tr('profile.notificationsNote'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)))),
      ])),
      const SizedBox(height: AppSpace.lg),
      SectionHeading(state.tr('profile.groupProperties')),
      _groupTile(title: state.tr('profile.groupProperties'), count: properties.length, icon: Icons.home_work_outlined, child: Column(children: [for (final property in properties) ListTile(contentPadding: EdgeInsets.zero, title: Text(state.text(property.name)), subtitle: Text(state.text(property.location)), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.of(context).pushNamed('/property/${property.id}'))])),
      _groupTile(title: state.tr('profile.groupRequests'), count: requests.length, icon: Icons.handyman_outlined, child: requests.isEmpty ? EmptyState(title: state.tr('profile.noRequests'), body: '') : Column(children: [for (final request in requests.take(5)) ListTile(contentPadding: EdgeInsets.zero, title: Text(state.tr('services.categories.${request.category}')), subtitle: Text('${request.reference} · ${formatDate(request.createdAt, state.language)}', textDirection: TextDirection.ltr), trailing: StatusChip(status: request.status), onTap: () => Navigator.of(context).pushNamed('/services'))])),
      _groupTile(title: state.tr('profile.groupInvoices'), count: invoices.length, icon: Icons.receipt_long_outlined, child: invoices.isEmpty ? EmptyState(title: state.tr('profile.noInvoices'), body: '') : Column(children: [for (final invoice in invoices) ListTile(contentPadding: EdgeInsets.zero, title: Text(state.text(invoice.description)), subtitle: Text(formatDate(invoice.createdAt, state.language)), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(formatMoney(invoice.amount, state.language), textDirection: TextDirection.ltr), Text(state.tr(invoice.status == 'paid' ? 'profile.paid' : 'profile.unpaid'), style: Theme.of(context).textTheme.bodySmall)]))])),
      ListTile(leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.primary), title: Text(state.tr('profile.groupSubscriptions')), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.of(context).pushNamed('/subscriptions')),
      const SizedBox(height: AppSpace.lg),
      SectionHeading(state.tr('profile.groupHelp')),
      SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(state.tr('profile.helpTitle'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpace.xs),
        Text(state.tr('profile.helpBody')),
        const SizedBox(height: AppSpace.sm),
        OutlinedButton.icon(onPressed: () => Navigator.of(context).pushNamed('/assistant'), icon: const Icon(Icons.auto_awesome_outlined), label: Text(state.tr('profile.openAssistant'))),
        const Divider(height: AppSpace.xl),
        Text(state.tr('profile.groupPrivacy'), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpace.xs),
        Text(state.tr('profile.privacyBody'), style: Theme.of(context).textTheme.bodySmall),
      ])),
      const SizedBox(height: AppSpace.lg),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () => _signOut(state), icon: const Icon(Icons.logout), label: Text(state.tr('profile.logout')))),
    ]);
  }
}
